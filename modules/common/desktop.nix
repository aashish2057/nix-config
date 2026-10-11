{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.profiles.desktop;
in {
  options.profiles.desktop.enable = lib.mkEnableOption "desktop machines (browser and GUI apps)";

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        home = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          pointerCursor = {
            enable = true;
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
            size = 24;
          };
          packages = [
            pkgs.ddcutil
            (pkgs.callPackage ../../pkgs/helium {
              enableWideVine = true;
            })
            pkgs.wl-clipboard
            pkgs.prismlauncher
            pkgs.obsidian
            pkgs.sunsetr
            pkgs.wayshot
            pkgs.satty
            pkgs.anki
            pkgs.legcord
          ];
        };
      }
    ];
  };
}
