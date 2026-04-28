{...}: {
  home-manager.sharedModules = [
    {
      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    }
  ];
}
