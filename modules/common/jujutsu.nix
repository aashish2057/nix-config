{
  isWork,
  system,
  ...
}: {
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
          templates = {
            git_push_bookmark = ''"aashish2057/" ++ change_id.short()'';
          };
          ui = {
            diff-formatter = ":git";
            bookmark-list-sort-keys = ["committer-date-"];
            pager = "delta";
            diff-editor = ["nvim" "-c" "DiffEditor $left $right $output"];
            format = "git";
          };
          aliases = {
            ll = ["log" "-r" "all()" "--limit" "20"];
            lll = ["log" "-r" "all()"];
            tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
          };
        };
      };
    }
  ];
}
