{lib, ...}: {
  programs.git = {
    enable = true;

    extraConfig = {
      push.autoSetupRemote = true;
      pull.rebase = true;
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519.pub";
    };

    delta = {
      enable = true;
      options.features = "side-by-side";
    };
  };
}
