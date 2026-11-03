# OmniOS VM for illumos development, managed by libvirt through NixVirt.
#
# The VM boots the OmniOS cloud image. cloud-init reads the seed disc on first
# boot: it sets the hostname, adds the dev user and SSH keys, installs the
# illumos build tools, and creates /build.
#
# Use `illumos-vm` on the host to reach it (ssh, console, sync, build, onu).
{
  config,
  pkgs,
  username,
  nixvirt,
  ...
}: let
  inherit (nixvirt) lib;

  name = "omnios";
  mac = "52:54:00:ce:a6:fb";
  ip = "192.168.122.10";
  devUser = "aashish";
  imagesDir = "/var/lib/libvirt/images";
  disk = "${imagesDir}/${name}.qcow2";
  qemu = config.virtualisation.libvirtd.qemu.package;

  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwvc5IIcWLoDPAiiCIvga7DtzhaKhP9ZtmFXflNCQTi homelab@homeserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJl0RgOAu7OxhvdbtZdU201rEVeEnTqzfJn025orzwob aashish2057@gmail.com"
  ];

  # Bloody tracks illumos-gate, so bits built from the gate install cleanly
  # with onu. The image is copied to the VM's disk once; changing it later
  # does not touch an existing disk.
  baseImage = pkgs.fetchurl {
    url = "https://downloads.omnios.org/media/bloody/omnios-bloody-20261007.cloud.qcow2";
    sha256 = "bec1578ca4faad438140f536ff53152e44341fcdc4eb5e0726c31bf008494372";
  };

  userData = pkgs.writeText "user-data" ''
    #cloud-config
    runcmd:
      - |
        set -x
        # Grow the root pool to fill the 200 GB disk.
        zpool set autoexpand=on rpool
        for d in $(zpool list -Hv -P rpool | awk 'NR > 1 { print $1 }'); do
          zpool online -e rpool "$d"
        done
        # Dev user with key-only SSH and pfexec (for onu and reboot).
        getent passwd ${devUser} || useradd -m -d /home/${devUser} -s /bin/bash -P "Primary Administrator" ${devUser}
        passwd -N ${devUser}
        mkdir -p /root/.ssh /home/${devUser}/.ssh
        cat > /home/${devUser}/.ssh/authorized_keys <<'EOF'
        ${builtins.concatStringsSep "\n    " sshKeys}
        EOF
        cp /home/${devUser}/.ssh/authorized_keys /root/.ssh/authorized_keys
        chown -R ${devUser} /home/${devUser}/.ssh
        chmod 700 /home/${devUser}/.ssh
        # Build tools and a dataset for the gate.
        pkg install -v illumos-tools || pkg install -v developer/illumos-tools
        zfs list rpool/build || zfs create -o mountpoint=/build rpool/build
        chown ${devUser} /build
  '';

  metaData = pkgs.writeText "meta-data" ''
    instance-id: ${name}-1
    local-hostname: ${name}
  '';

  # cloud-init NoCloud seed: an ISO 9660 disc labelled "cidata".
  seed = pkgs.runCommand "${name}-seed.iso" {nativeBuildInputs = [pkgs.cdrkit];} ''
    mkdir seed
    cp ${userData} seed/user-data
    cp ${metaData} seed/meta-data
    genisoimage -quiet -output $out -volid cidata -joliet -rock seed
  '';

  # Plain OVMF, without Secure Boot, because the illumos loader is not signed.
  ovmf = pkgs.OVMF.fd;

  domain = {
    type = "kvm";
    inherit name;
    uuid = "c0bb1ac9-30d1-4c60-bb91-40b552d0220a";
    vcpu.count = 4;
    memory = {
      count = 24;
      unit = "GiB";
    };

    os = {
      type = "hvm";
      arch = "x86_64";
      machine = "q35";
      loader = {
        readonly = true;
        type = "pflash";
        path = "${ovmf}/FV/OVMF_CODE.fd";
      };
      nvram = {
        template = "${ovmf}/FV/OVMF_VARS.fd";
        path = "/var/lib/libvirt/qemu/nvram/${name}_VARS.fd";
      };
      boot = [{dev = "hd";}];
      bootmenu.enable = true;
    };

    features = {
      acpi = {};
      apic = {};
    };
    cpu.mode = "host-passthrough";
    clock.offset = "utc";

    devices = {
      emulator = "${qemu}/bin/qemu-system-x86_64";

      disk = [
        {
          type = "file";
          device = "disk";
          driver = {
            name = "qemu";
            type = "qcow2";
            cache = "none";
            discard = "unmap";
          };
          source.file = disk;
          # virtio-blk uses the illumos vioblk driver. If the disk isn't
          # found, use { dev = "sda"; bus = "sata"; }.
          target = {
            dev = "vda";
            bus = "virtio";
          };
        }
        {
          type = "file";
          device = "cdrom";
          driver = {
            name = "qemu";
            type = "raw";
          };
          source.file = "${seed}";
          target = {
            dev = "sdc";
            bus = "sata";
          };
          readonly = true;
        }
      ];

      interface = {
        type = "network";
        mac.address = mac;
        source.network = "default";
        # virtio-net uses the illumos vioif driver. Use "e1000" if it fails.
        model.type = "virtio";
      };

      # Serial console for the loader, the kernel, and panics:
      # `virsh console omnios`.
      serial = {
        type = "pty";
        target.port = 0;
      };
      console = {
        type = "pty";
        target = {
          type = "serial";
          port = 0;
        };
      };

      # VGA fallback, local to the host only.
      graphics = {
        type = "vnc";
        autoport = true;
        listen = {
          type = "address";
          address = "127.0.0.1";
        };
      };
      video.model = {
        type = "vga";
        primary = true;
      };
    };
  };

  # Host-side helper for the illumos workflow.
  illumos-vm = pkgs.writeShellApplication {
    name = "illumos-vm";
    runtimeInputs = [pkgs.openssh pkgs.git pkgs.libvirt pkgs.coreutils];
    # Commands for the VM are built on the host on purpose.
    excludeShellChecks = ["SC2029"];
    text = ''
      vm=${devUser}@${ip}
      gate=''${ILLUMOS_GATE:-$HOME/Dev/illumos-gate}
      remote_gate=/build/illumos-gate
      ssh_opts=(-o StrictHostKeyChecking=accept-new)

      run() { ssh "''${ssh_opts[@]}" "$vm" "$@"; }

      usage() {
        cat <<EOF
      Usage: illumos-vm COMMAND

        ssh [ARGS]     SSH to the VM as ${devUser}
        console        Attach to the VM's serial console (exit with Ctrl-])
        sync [REV]     Push REV (default @-) to $remote_gate in the VM and check it out
        build [-i]     Run a nightly build in the VM (-i: incremental)
        onu            Install the last build into a new boot environment and reboot
      EOF
      }

      case "''${1:-}" in
        ssh)
          shift
          run "$@"
          ;;
        console)
          exec virsh -c qemu:///system console ${name}
          ;;
        sync)
          rev=''${2:-@-}
          commit=$(jj -R "$gate" log --no-graph -r "$rev" -T commit_id)
          run "test -d $remote_gate/.git || git init -q $remote_gate"
          GIT_SSH_COMMAND="ssh ''${ssh_opts[*]}" \
            git -C "$gate" push -f "ssh://$vm$remote_gate" "$commit:refs/heads/vm-build"
          run "cd $remote_gate && git checkout -q -f --detach vm-build && git log -1 --oneline"
          ;;
        build)
          flags=""
          [ "''${2:-}" = "-i" ] && flags="-i"
          run "cd $remote_gate \
            && { test -f illumos.sh || cp /opt/onbld/env/omnios-illumos-gate illumos.sh; } \
            && ./usr/src/tools/scripts/nightly $flags ./illumos.sh; \
            status=\$?; cat \$(ls -td log/log.* | head -1)/mail_msg 2>/dev/null | tail -40; exit \$status"
          ;;
        onu)
          be="nightly-$(date -u +%Y%m%d-%H%MZ)"
          run "cd $remote_gate \
            && pfexec ./usr/src/tools/proto/root_i386-nd/opt/onbld/bin/onu -t $be -d packages/i386/nightly \
            && pfexec reboot"
          ;;
        *)
          usage
          ;;
      esac
    '';
  };
in {
  imports = [nixvirt.nixosModules.default];

  users.users.${username}.extraGroups = ["libvirtd"];
  environment.systemPackages = [illumos-vm];

  # Copy the cloud image to the VM's disk once, then grow it to 200 GB.
  systemd.services."${name}-disk" = {
    description = "Create the ${name} VM disk from the OmniOS cloud image";
    wantedBy = ["multi-user.target"];
    before = ["nixvirt.service"];
    requiredBy = ["nixvirt.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -e ${disk}.imaged ]; then
        ${qemu}/bin/qemu-img convert -O qcow2 ${baseImage} ${disk}.tmp
        ${qemu}/bin/qemu-img resize ${disk}.tmp 200G
        mv ${disk}.tmp ${disk}
        touch ${disk}.imaged
      fi
    '';
  };

  virtualisation.libvirt = {
    enable = true;
    connections."qemu:///system" = {
      networks = [
        {
          definition = lib.network.writeXML (lib.network.templates.bridge {
            uuid = "8cda6f30-7dd0-4eaa-8754-97df6849cbed";
            subnet_byte = 122;
            dhcp_hosts = [{inherit mac name ip;}];
          });
          active = true;
        }
      ];

      domains = [
        {
          definition = lib.domain.writeXML domain;
          active = true;
        }
      ];
    };
  };

  systemd.tmpfiles.rules = ["d ${imagesDir} 0711 root root -"];
}
