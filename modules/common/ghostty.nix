{
  pkgs,
  lib,
  username,
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
            theme = "Material Ocean";
            font-family = "Berkley Mono";
            shell-integration-features = "no-cursor";
            cursor-style = "block";
            cursor-style-blink = false;
            window-theme = "ghostty";
            working-directory = "/Users/${username}/Dev";
            macos-titlebar-style = "hidden";
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
