{lib, ...}: {
  programs.git = {
    enable = true;

    userName = "__git config user.name__";
    userEmail = "__git config user.email__";

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
