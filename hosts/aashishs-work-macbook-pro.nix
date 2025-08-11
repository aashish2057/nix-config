{
  config,
  pkgs,
  pkgs-unstable,
  system,
  username,
  ...
}: {
  imports = [
    ../modules/common/core.nix
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
}
