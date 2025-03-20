{
  config,
  pkgs,
  system,
  ...
}: {
  imports = [
    ../../modules/nix-core.nix
    ../../modules/system.nix
    ../../modules/homebrew.nix
  ];

  system = {
    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Ghostty.app"
          "/Applications/Slack.app"
        ];
      };
    };
  };

  homebrew = {
    casks = [
      "slack"
    ];
  };
}
