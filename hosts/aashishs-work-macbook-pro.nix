{
  config,
  pkgs,
  pkgs-unstable,
  system,
  username,
  ...
}: {
  imports = [
    ../modules/core.nix
    ../modules/darwin.nix
    ../modules/homebrew.nix
  ];
}
