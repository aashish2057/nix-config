{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    home-manager.sharedModules = [
      {
        xdg.configFile."sunsetr/sunsetr.toml".source = ./sunsetr/sunsetr.toml;
      }
    ];
  };
}
