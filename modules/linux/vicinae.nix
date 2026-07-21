{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.vicinae = {
        enable = true;
        systemd.enable = true;
      };

      home.file.".local/share/vicinae/scripts/usb-c-suspend.sh" = {
        executable = true;
        text = ''
          #!${pkgs.runtimeShell}
          # @vicinae.schemaVersion 1
          # @vicinae.title Switch to USB-C and Suspend
          # @vicinae.mode silent

          ${lib.getExe pkgs.ddcutil} setvcp 60 0x0f && \
            ${pkgs.systemd}/bin/systemd-run --user --quiet --collect \
              --on-active=5s ${pkgs.systemd}/bin/systemctl suspend
        '';
      };
    }
  ];
}
