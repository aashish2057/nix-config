# OmniOS VM for illumos development, managed by libvirt through NixVirt.
#
# Reach it with `ssh -J homelab@homeserver <user>@192.168.122.10` and its
# serial console with `virsh console omnios`.
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
  imagesDir = "/var/lib/libvirt/images";

  # Bloody tracks illumos-gate, so bits built from the gate install cleanly
  # with onu. Set to null after the install to eject the disc.
  installer = pkgs.fetchurl {
    url = "https://downloads.omnios.org/media/bloody/omnios-bloody-20261007.iso";
    sha256 = "e1a56c4fbe7b353a2468866a27021c64b21789952d3e362c706559e447b9898e";
  };

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
      # The disk is empty until the install, so UEFI falls through to the disc.
      boot = [{dev = "hd";} {dev = "cdrom";}];
      bootmenu.enable = true;
    };

    features = {
      acpi = {};
      apic = {};
    };
    cpu.mode = "host-passthrough";
    clock.offset = "utc";

    devices = {
      emulator = "${config.virtualisation.libvirtd.qemu.package}/bin/qemu-system-x86_64";

      disk =
        [
          {
            type = "volume";
            device = "disk";
            driver = {
              name = "qemu";
              type = "qcow2";
              cache = "none";
              discard = "unmap";
            };
            source = {
              pool = "default";
              volume = "${name}.qcow2";
            };
            # virtio-blk uses the illumos vioblk driver. If the installer
            # can't see the disk, use { dev = "sda"; bus = "sata"; }.
            target = {
              dev = "vda";
              bus = "virtio";
            };
          }
        ]
        ++ pkgs.lib.optional (installer != null) {
          type = "file";
          device = "cdrom";
          driver = {
            name = "qemu";
            type = "raw";
          };
          source.file = "${installer}";
          target = {
            dev = "sdc";
            bus = "sata";
          };
          readonly = true;
        };

      interface = {
        type = "network";
        mac.address = mac;
        source.network = "default";
        # virtio-net uses the illumos vioif driver. Use "e1000" if it fails.
        model.type = "virtio";
      };

      # Serial console for the loader, the kernel, and panics.
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

      # VGA console for the installer, local to the host. Tunnel it with
      # `ssh -L 5900:127.0.0.1:5900 homelab@homeserver`.
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
      input = [
        {
          type = "tablet";
          bus = "usb";
        }
        {
          type = "keyboard";
          bus = "ps2";
        }
      ];
    };
  };
in {
  imports = [nixvirt.nixosModules.default];

  users.users.${username}.extraGroups = ["libvirtd"];

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

      pools = [
        {
          definition = lib.pool.writeXML {
            name = "default";
            uuid = "f611a75b-2776-40c4-8bd1-0113a6c104e3";
            type = "dir";
            target.path = imagesDir;
          };
          active = true;
          volumes = [
            {
              definition = lib.volume.writeXML {
                name = "${name}.qcow2";
                capacity = {
                  count = 200;
                  unit = "GiB";
                };
                target.format.type = "qcow2";
              };
            }
          ];
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
