{pkgs-unstable, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home-manager.sharedModules = [
    {
      # services.hyprsunset = {
      #   enable = true;
      #   package = pkgs-unstable.hyprsunset;
      #   settings = {
      #     profile = [
      #       {
      #         time = "5:30";
      #         temperature = 3400;
      #       }
      #
      #       {
      #         time = "8:00";
      #         temperature = 6500;
      #       }
      #
      #       {
      #         time = "17:00";
      #         temperature = 2700;
      #       }
      #     ];
      #   };
      # };
      # services.hyprpaper = {
      #   enable = true;
      #   settings = {
      #     preload = ["Documents/wallpaper2.png"];
      #     wallpaper = [",Documents/wallpaper2.png"];
      #   };
      # };
      xdg.portal.config.common.default = "*";
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        settings = {
          monitor = ["DP-2,3840x2160@160,0x0,1.5"];

          "$terminal" = "ghostty";

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          ];

          exec-once = [
            "hyprpaper"
            "hyprsunset"
          ];

          general = {
            gaps_in = 5;
            gaps_out = 0;
            border_size = 0;
            "col.active_border" = "rgba(00000000)";
            "col.inactive_border" = "rgba(00000000)";
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            rounding_power = 2;
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = false;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
          };

          master = {
            new_status = "master";
          };

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = false;
          };

          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";
            repeat_rate = 50;
            repeat_delay = 300;
            follow_mouse = 1;
            sensitivity = -0.75;
            natural_scroll = false;
          };

          "$mainMod" = "SUPER";

          bind = [
            "$mainMod, Return, exec, $terminal"
            "$mainMod, B, exec, chromium --ozone-platform=wayland"
            "$mainMod, W, killactive,"
            "$mainMod, O, exit,"
            "$mainMod, space, togglesplit,"
            "$mainMod, N, exec, obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland"

            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, j, movefocus, d"
            "$mainMod, k, movefocus, u"

            "$mainMod SHIFT, h, movewindow, l"
            "$mainMod SHIFT, l, movewindow, r"
            "$mainMod SHIFT, j, movewindow, d"
            "$mainMod SHIFT, k, movewindow, u"

            "$mainMod SHIFT, left, resizeactive, -20 0"
            "$mainMod SHIFT, right, resizeactive, 20 0"
            "$mainMod SHIFT, up, resizeactive, 0 -20"
            "$mainMod SHIFT, down, resizeactive, 0 20"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
          ];

          windowrule = [
            "suppressevent maximize, class:.*"
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];
        };
      };
    }
  ];
}
