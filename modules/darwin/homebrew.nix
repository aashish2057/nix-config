{
  lib,
  isWork,
  ...
}: {
  homebrew = {
    enable = true;

    # Manual installation required with HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql18 mssql-tools18
    brews =
      []
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
        "kitlangton-hex"
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
      []
      ++ lib.optionals isWork [
        "microsoft/mssql-release"
        "contribsys/faktory"
      ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
      extraFlags = ["--force-cleanup"];
    };
  };
}
