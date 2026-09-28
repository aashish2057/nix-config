{
  pkgs,
  lib,
  ...
}: let
  displaySwitch = pkgs.callPackage ../../pkgs/display-switch {};
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  configText = ''
    usb_device = "3434:d028"
    on_usb_connect = ${
      if isLinux
      then "0x0f"
      else "0x1a"
    }
    on_usb_disconnect = ${
      if isLinux
      then "0x1a"
      else "0x0f"
    }
  '';
in {
  home-manager.sharedModules = [
    {
      home.packages = [displaySwitch];

      xdg.configFile."display-switch/display-switch.ini" = lib.mkIf isLinux {
        text = configText;
      };

      home.file."Library/Preferences/display-switch.ini" = lib.mkIf (!isLinux) {
        text = configText;
      };

      systemd.user.services.display-switch = lib.mkIf isLinux {
        Unit.Description = "Switch display input with the USB switch";
        Service = {
          ExecStart = lib.getExe displaySwitch;
          Restart = "always";
        };
        Install.WantedBy = ["default.target"];
      };

      launchd.agents.display-switch = lib.mkIf (!isLinux) {
        enable = true;
        config = {
          ProgramArguments = [
            (lib.getExe displaySwitch)
          ];
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    }
  ];
}
