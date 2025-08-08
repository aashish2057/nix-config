{
  pkgs,
  pkgs-unstable,
  config,
  username,
  homedir,
  ...
}: {
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.fzf
    pkgs.zsh-fzf-history-search
    pkgs.zsh-fzf-tab
    pkgs.ripgrep
    pkgs.alejandra
    pkgs.yazi
    pkgs-unstable.nh
    pkgs.nodejs_22
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
