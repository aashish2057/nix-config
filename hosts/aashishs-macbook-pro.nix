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
          "/Applications/Obsidian.app"
        ];
      };
    };
  };
}
