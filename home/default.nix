{
  pkgs,
  username,
  homedir,
  ...
}: {
  imports = [
    ./core.nix
    ./git.nix
  ];

  home = {
    username = username;
    homeDirectory = homedir;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
