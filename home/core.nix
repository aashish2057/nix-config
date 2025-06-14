{
  pkgs,
  config,
  username,
  homedir,
  ...
}: {
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fzf
    zsh-fzf-history-search
    zsh-fzf-tab
    ripgrep
    gh
    alejandra
    nodejs_22
    yazi
    nh
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  home.file = {
    ".hushlogin".text = "";
  };

  xdg.configFile = {
    ghostty = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dev/nix-config/dotfiles/ghostty";
    };
    nvim = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dev/nix-config/dotfiles/nvim";
    };
    aerospace = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dev/nix-config/dotfiles/aerospace";
    };
  };
}
