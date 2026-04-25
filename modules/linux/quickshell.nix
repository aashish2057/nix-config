{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.quickshell = {
        enable = true;
        configs.main = ./quickshell;
        activeConfig = "main";
      };
    }
  ];
}
