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
    docker
    colima
    lazydocker
    dotnet-sdk
    azurite
    azure-cli
    nodejs_22
    pnpm
    foreman
  ];
}
