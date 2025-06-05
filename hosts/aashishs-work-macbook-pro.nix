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
      dotnet-ef
      azurite
      azure-cli
      pnpm
      azure-cli
      kubectl
      kubelogin
      k9s
    ];
  };
}
