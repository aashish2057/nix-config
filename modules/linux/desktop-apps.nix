{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    home-manager.sharedModules = [
      {
        home = {
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
