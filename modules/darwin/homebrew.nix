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
        "postgresql@14"
        "colima"
        "docker"
      ];

    casks =
      [
        "ghostty"
        "obsidian"
        "flux-app"
        "appcleaner"
        "hex"
        "tinycast"
      ]
      ++ lib.optionals isWork [
        "slack"
        "zoom"
        "datagrip"
        "rider"
        "modern-csv"
        "visual-studio-code"
        "cursor"
        "cursor-cli"
      ]
      ++ lib.optionals (!isWork) [
        "legcord"
        "mullvad-vpn"
        "tailscale-app"
        "anki"
      ];

    taps =
      [
        {
          name = "abue-ammar/tinycast";
          trusted = true;
        }
        {
          name = "anomalyco/tap";
          trusted = true;
        }
      ]
      ++ lib.optionals isWork [
        {
          name = "microsoft/mssql-release";
          trusted = true;
        }
        {
          name = "contribsys/faktory";
          trusted = true;
        }
      ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
      extraFlags = ["--force-cleanup"];
      extraEnv = lib.optionalAttrs isWork {
        HOMEBREW_ACCEPT_EULA = "Y";
      };
    };
  };
}
