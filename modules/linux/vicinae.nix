{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.vicinae = {
        enable = true;
        systemd.enable = true;
      };
    }
  ];
}
