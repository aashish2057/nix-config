{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        package =
          if pkgs.stdenv.isDarwin
          then null
          else pkgs.ghostty;
        settings =
          {
            theme = "MaterialOcean";
            font-family = "GeistMono NFM";
            shell-integration-features = "no-cursor";
            cursor-style = "bar";
            cursor-style-blink = false;
            window-theme = "ghostty";
          }
          // lib.optionalAttrs pkgs.stdenv.isLinux {
            gtk-tabs-location = "bottom";
            gtk-titlebar = false;
            window-decoration = "none";
          };
      };
    }
  ];
}
