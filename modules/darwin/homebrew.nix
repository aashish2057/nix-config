{
  lib,
  isWork,
  ...
}: {
  homebrew = {
    enable = true;

    casks =
      [
        "raycast"
        "ghostty"
        "obsidian"
        "font-geist-mono-nerd-font"
        "aerospace"
        "flux-app"
        "jordanbaird-ice"
        "appcleaner"
      ]
      ++ lib.optionals isWork [
        "slack"
        "zoom"
        "tunnelblick"
        "datagrip"
        "rider"
        "google-chrome"
        "microsoft-azure-storage-explorer"
        "modern-csv"
        "visual-studio-code"
      ]
      ++ lib.optionals (!isWork) [
        "legcord"
        "utm"
        "anki"
        "mullvad-vpn"
        "tailscale-app"
      ];

    taps = [
      "nikitabobko/tap"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
