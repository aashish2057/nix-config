{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.quickshell = {
        enable = true;
      };
    }
  ];
}
