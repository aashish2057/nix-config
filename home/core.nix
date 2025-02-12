{pkgs, ...}: {
  home.packages = with pkgs; [
    git
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
