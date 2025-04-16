{
  pkgs,
  config,
  username,
  homedir,
  ...
}: {
  imports = [
    ../home/core.nix
    ../home/git.nix
    ../home/shell.nix
    ../home/starship.nix
  ];

  programs.git = {
    userName = "aashish2057";
    userEmail = "aashish.sharma@shelfengine.com";
  };

  home.packages = with pkgs; [
    docker
    colima
    lazydocker
    # Work project is dotnet 8, roslyn lsp is dotnet 9
    (with dotnetCorePackages;
      combinePackages [
        sdk_8_0
        sdk_9_0
      ])
    azurite
    azure-cli
    pnpm
    foreman
  ];
}
