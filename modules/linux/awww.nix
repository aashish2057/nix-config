{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    home-manager.sharedModules = [
      {
        services.awww = {
          enable = true;
        };
      }
    ];
  };
}
