{pkgs, ...}: {
  home.packages = with pkgs; [
    cowsay
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
