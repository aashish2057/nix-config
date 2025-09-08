{...}: {
  home-manager.sharedModules = [
    {
      programs.aerospace = {
        enable = true;

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
            outer.left = 0;
            outer.bottom = 0;
            outer.top = 0;
            outer.right = 0;
          };

          mode.main.binding = {
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            alt-shift-left = "resize smart +50";
            alt-shift-right = "resize smart -50";

            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";

            alt-shift-1 = ["move-node-to-workspace 1" "workspace 1"];
            alt-shift-2 = ["move-node-to-workspace 2" "workspace 2"];
            alt-shift-3 = ["move-node-to-workspace 3" "workspace 3"];

            alt-shift-t = "layout tiles horizontal vertical";

            alt-shift-f = ["layout floating tiling" "mode main"];
          };
        };
      };
    }
  ];
}
