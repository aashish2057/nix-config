{
  config,
  pkgs,
  system,
  ...
}: {
  imports = [
    ../modules/nix-core.nix
    ../modules/system.nix
    ../modules/homebrew.nix
  ];

  system = {
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
    ];
  };
}
