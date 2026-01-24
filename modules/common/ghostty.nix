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
        themes = {
          Kanso = {
            palette = [
              "0=#090E13"
              "1=#c4746e"
              "2=#8a9a7b"
              "3=#c4b28a"
              "4=#8ba4b0"
              "5=#a292a3"
              "6=#8ea4a2"
              "7=#a4a7a4"
              "8=#5C6066"
              "9=#e46876"
              "10=#87a987"
              "11=#e6c384"
              "12=#7fb4ca"
              "13=#938aa9"
              "14=#7aa89f"
              "15=#c5c9c7"
            ];
            background = "#090E13";
            foreground = "#c5c9c7";
            cursor-color = "#c5c9c7";
            selection-background = "#22262D";
            selection-foreground = "#c5c9c7";
          };
        };
        settings =
          {
            theme = "Kanso";
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
