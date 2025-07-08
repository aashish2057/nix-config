{
  config,
  pkgs,
  pkgs-unstable,
  system,
  username,
  ...
}: {
  imports = [
    ../modules/nix-core.nix
    ../modules/darwin.nix
    ../modules/homebrew.nix
  ];

  system = {
    primaryUser = username;
    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Helium.app"
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
      "tailscale"
    ];
  };

  # Home Manager configuration
  home-manager.users.${username} = {
    pkgs,
    pkgs-unstable,
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

    home.packages = [
      pkgs.cowsay
    ];
  };
}
