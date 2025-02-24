{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    cowsay
    fzf
    zsh-fzf-history-search
    zsh-fzf-tab
    ripgrep
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      prefix = "C-Space";
      shell = "/bin/zsh";
      extraConfig = builtins.readFile ../dotfiles/tmux/tmux.conf;
      plugins = [
        {
          plugin = pkgs.tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
      ];
    };
  };

  home.file = {
    ".hushlogin".text = "";
  };

  xdg.configFile = {
    ghostty = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Desktop/nix-config/dotfiles/ghostty";
    };
    nvim = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Desktop/nix-config/dotfiles/nvim";
    };
  };
}
