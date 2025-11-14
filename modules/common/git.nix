{isWork, ...}: {
  home-manager.sharedModules = [
    {
      programs.git = {
        enable = true;

        settings = {
          user = {
            name = "aashish2057";
            email =
              if isWork
              then "aashish.sharma@gocrisp.com"
              else "aashish2057@gmail.com";
          };
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
      };
    }
  ];
}
