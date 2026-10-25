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
          package = lib.mkDefault (pkgs.callPackage ../../pkgs/t3code {});
        };
      }
    ];
  };
}
