{pkgs, ...}: {
  home-manager.sharedModules = [
    {
      programs.mise = {
        enable = true;
        enableZshIntegration = true;
      };
    }
  ];
}
