{isWork, ...}: {
  home-manager.sharedModules = [
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "aashish2057";
            email =
              if isWork
              then "aashish.sharma@gocrisp.com"
              else "aashish2057@gmail.com";
          };
          signing = {
            behavior = "own";
            backend = "ssh";
            key = "~/.ssh/id_ed25519.pub";
          };
          ui = {
            diff-formatter = ["difft" "--color=always" "$left" "$right"];
            bookmark-list-sort-keys = ["committer-date-"];
          };
        };
      };
    }
  ];
}
