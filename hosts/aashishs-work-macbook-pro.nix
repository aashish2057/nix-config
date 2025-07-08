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
          "/Applications/DataGrip.app"
          "/Applications/Obsidian.app"
          "/Applications/Slack.app"
          "/Applications/zoom.us.app"
        ];
      };
    };
  };

  homebrew = {
    casks = [
      "slack"
      "zoom"
      "tunnelblick"
      "datagrip"
      "rider"
      "google-chrome"
      "microsoft-azure-storage-explorer"
      "modern-csv"
      "visual-studio-code"
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
      userEmail = "aashish.sharma@gocrisp.com";
    };

    home.packages = [
      pkgs.docker
      pkgs.colima
      pkgs.lazydocker
      # Work project is dotnet 8, roslyn lsp is dotnet 9
      (with pkgs.dotnetCorePackages;
        pkgs.dotnetCorePackages.combinePackages [
          sdk_8_0
          sdk_9_0
        ])
      pkgs.dotnet-ef
      pkgs.azurite
      pkgs.azure-cli
      pkgs.pnpm
      pkgs.kubectl
      pkgs.kubelogin
      pkgs.k9s
      pkgs.nodejs_22
    ];
  };
}
