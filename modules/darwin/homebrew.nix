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
        "ghui"
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
        "flux-app"
        "appcleaner"
      ]
      ++ lib.optionals isWork [
        "slack"
        "zoom"
        "datagrip"
        "rider"
        "modern-csv"
        "visual-studio-code"
      ]
      ++ lib.optionals (!isWork) [
        "legcord"
        "mullvad-vpn"
        "tailscale-app"
        "anki"
      ];

    taps =
      [
        "nikitabobko/tap"
        "kitlangton/tap"
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
