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
          "/Applications/Obsidian.app"
        ];
      };
    };
  };

  homebrew = {
    casks = [
      "cold-turkey-blocker"
      "legcord"
      "utm"
      "anki"
      "rode-central"
    ];
  };
}
