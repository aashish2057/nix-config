{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    services.displayManager.defaultSession = "niri";

    home-manager.sharedModules = [
      {
        home.packages = [
          pkgs.xwayland-satellite
        ];

        xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
      }
    ];
  };
}
