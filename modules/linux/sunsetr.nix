{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      xdg.configFile."sunsetr/sunsetr.toml".source = ./sunsetr/sunsetr.toml;
    }
  ];
}
