{pkgs, ...}: {
  home.packages = with pkgs; [
    cowsay
    fzf
    zsh-fzf-history-search
    zsh-fzf-tab
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
