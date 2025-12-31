{
  isWork,
  system,
  jj-starship,
  ...
}: {
  home-manager.sharedModules = [
    {
      home.packages = [
        jj-starship.packages.${system}.default
      ];

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
          templates = {
            git_push_bookmark = ''"aashish2057/" ++ change_id.short()'';
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
