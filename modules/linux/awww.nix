{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      services.awww = {
        enable = true;
      };
    }
  ];
}
