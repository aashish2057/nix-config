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
    userEmail = "aashish2057@gmail.com";
  };
}
