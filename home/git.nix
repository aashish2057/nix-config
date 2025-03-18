{lib, ...}: {
  programs.git = {
    enable = true;

    extraConfig = {
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    delta = {
      enable = true;
      options.features = "side-by-side";
    };
  };
}
