{pkgs, ...}: {
  home-manager.sharedModules = [
    {
      programs.t3code = {
        enable = true;
        package = pkgs.callPackage ../../pkgs/t3code {};
      };
    }
  ];
}
