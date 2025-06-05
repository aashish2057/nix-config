{
  config,
  pkgs,
  system,
  username,
  ...
}: {
  imports = [
    ../modules/nix-core.nix
    ../modules/system.nix
    ../modules/homebrew.nix
  ];

  system = {
    primaryUser = username;
    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Ghostty.app"
          "/Applications/Obsidian.app"
        ];
      };
    };
  };

  homebrew = {
    casks = [
      "cold-turkey-blocker"
      "legcord"
      "utm"
      "anki"
      "mullvad-vpn"
    ];
  };

  # Home Manager configuration
  home-manager.users.${username} = {
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
      userEmail = "aashish2057@gmail.com";
    };

    home.packages = with pkgs; [
      cowsay
    ];
  };
}
