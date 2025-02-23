{
  self,
  lib,
  pkgs,
  system,
  ...
}: {
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
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
      };
    };
  };
}
