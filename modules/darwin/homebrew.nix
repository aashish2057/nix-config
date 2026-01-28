{
  lib,
  isWork,
  ...
}: {
  homebrew = {
    enable = true;

    # Manual installation required with HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql18 mssql-tools18
    brews =
      [
        "lumen"
      ]
      ++ lib.optionals isWork [
        "msodbcsql18"
        "mssql-tools18"
        "faktory"
        "ca-certificates"
        "m4"
        "libtool"
        "openssl@3"
        "redis"
        "unixodbc"
        "postgresql"
      ];

    casks =
      [
        "raycast"
        "ghostty"
        "obsidian"
        "font-geist-mono-nerd-font"
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
        # "mochi"
        "tailscale-app"
      ];

    taps =
      [
        "nikitabobko/tap"
        "jnsahaj/lumen"
      ]
      ++ lib.optionals isWork [
        "microsoft/mssql-release"
        "contribsys/faktory"
      ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
