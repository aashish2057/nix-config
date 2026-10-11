{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    home-manager.sharedModules = [
      {
        programs.t3code = {
          enable = true;
          package = pkgs.callPackage ../../pkgs/t3code {};
        };
      }
    ];
  };
}
