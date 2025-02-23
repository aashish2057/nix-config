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
