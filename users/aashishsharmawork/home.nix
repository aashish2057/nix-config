{
  pkgs,
  config,
  username,
  homedir,
  ...
}: {
  imports = [
    ../../home/core.nix
    ../../home/git.nix
    ../../home/shell.nix
    ../../home/starship.nix
  ];

  programs.git = {
    userName = "aashish2057";
    userEmail = "aashish.sharma@shelfengine.com";
  };

  home.packages = with pkgs; [
    btop
  ];
}
