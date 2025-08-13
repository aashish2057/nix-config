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
        clearDefaultKeybinds = true;
        settings =
          {
            theme = "MaterialOcean";
            font-family = "GeistMono NFM";
            shell-integration-features = "no-cursor";
            cursor-style = "bar";
            cursor-style-blink = false;
            window-theme = "ghostty";
            keybind = [
              "ctrl+t=new_tab"
              "ctrl+w=close_tab"
              "ctrl+one=goto_tab:1"
              "ctrl+two=goto_tab:2"
              "ctrl+three=goto_tab:3"
              "ctrl+four=goto_tab:4"
              "ctrl+five=goto_tab:5"
              "ctrl+six=goto_tab:6"
              "ctrl+plus=increase_font_size:1"
              "ctrl+minus=decrease_font_size:1"
              "ctrl+shift+comma=reload_config"
              "super+q=quit"
            ];
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
