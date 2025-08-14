{...}: {
  home-manager.sharedModules = [
    {
      programs.aerospace = {
        enable = true;
        launchd = {
          enable = true;
          keepAlive = true;
        };

        userSettings = {
          default-root-container-layout = "tiles";
          on-focus-changed = ["move-mouse window-force-center"];

          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

          accordion-padding = 30;

          default-root-container-orientation = "auto";

          on-window-detected = [
            {
              "if".app-id = "com.mitchellh.ghostty";
              run = [
                "layout floating"
              ];
            }
          ];

          gaps = {
            inner.horizontal = 5;
            inner.vertical = 5;
            outer.left = 5;
            outer.bottom = 5;
            outer.top = 5;
            outer.right = 5;
          };

          mode.main.binding = {
            ctrl-alt-cmd-h = "focus left";
            ctrl-alt-cmd-j = "focus down";
            ctrl-alt-cmd-k = "focus up";
            ctrl-alt-cmd-l = "focus right";

            ctrl-alt-cmd-shift-h = "move left";
            ctrl-alt-cmd-shift-j = "move down";
            ctrl-alt-cmd-shift-k = "move up";
            ctrl-alt-cmd-shift-l = "move right";

            ctrl-alt-cmd-shift-left = "resize smart +50";
            ctrl-alt-cmd-shift-right = "resize smart -50";

            ctrl-alt-cmd-1 = "workspace 1";
            ctrl-alt-cmd-2 = "workspace 2";
            ctrl-alt-cmd-3 = "workspace 3";

            ctrl-alt-cmd-shift-1 = ["move-node-to-workspace 1" "workspace 1"];
            ctrl-alt-cmd-shift-2 = ["move-node-to-workspace 2" "workspace 2"];
            ctrl-alt-cmd-shift-3 = ["move-node-to-workspace 3" "workspace 3"];

            ctrl-alt-cmd-t = "layout tiles horizontal vertical";

            ctrl-alt-cmd-f = ["layout floating tiling" "mode main"];
          };
        };
      };
    }
  ];
}
