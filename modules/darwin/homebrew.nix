{
  lib,
  isWork,
  ...
}: {
  homebrew = {
    enable = true;

    # Manual installation required with HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql18 mssql-tools18
    brews = [
      "msodbcsql18"
      "mssql-tools18"
    ];

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
        "microsoft-azure-storage-explorer"
        "modern-csv"
        "visual-studio-code"
      ]
      ++ lib.optionals (!isWork) [
        "legcord"
        "mullvad-vpn"
        "mochi"
      ];

    taps =
      [
        "nikitabobko/tap"
      ]
      ++ lib.optionals isWork [
        "microsoft/mssql-release"
      ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
