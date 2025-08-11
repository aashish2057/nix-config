{
  self,
  lib,
  pkgs,
  system,
  username,
  isWork ? false,
  ...
}: {
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
    primaryUser = username;
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.4;
        largesize = 97;
        magnification = true;
        mru-spaces = false;
        orientation = "left";
        show-recents = false;
        tilesize = 31;
        persistent-apps =
          [
            "/Applications/Helium.app"
            "/Applications/Ghostty.app"
            "/Applications/Obsidian.app"
          ]
          ++ lib.optionals isWork [
            "/Applications/Slack.app"
            "/Applications/zoom.us.app"
          ];
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
        NewWindowTarget = "Documents";
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
        ShowStatusBar = true;
      };
      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
        "com.apple.swipescrolldirection" = false;
        _HIHideMenuBar = true;
      };
      WindowManager = {
        EnableStandardClickToShowDesktop = false;
      };
    };
  };
}
