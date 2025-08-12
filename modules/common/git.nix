{isWork, ...}: {
  home-manager.sharedModules = [
    {
      programs.git = {
        userName = "aashish2057";
        userEmail =
          if isWork
          then "aashish.sharma@gocrisp.com"
          else "aashish2057@gmail.com";

        enable = true;

        extraConfig = {
          push.autoSetupRemote = true;
          pull.rebase = true;
          fetch.prune = true;
          fetch.writeCommitGraph = true;
          branch.sort = "-committerdate";
          commit.gpgSign = true;
          tag.gpgSign = true;
          gpg.format = "ssh";
          user.signingKey = "~/.ssh/id_ed25519.pub";
        };

        delta = {
          enable = true;
          options.features = "side-by-side";
          options.tabs = 4;
        };
      };
    }
  ];
}
