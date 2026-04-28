{...}: {
  programs.fish.enable = true;

  home-manager.sharedModules = [
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -g fish_greeting
          set -g fish_autocd 1
          source (COMPLETE=fish jj | psub)
          fish_add_path ~/.npm-global/bin
          fish_add_path /opt/homebrew/bin
        '';
      };
    }
  ];
}
