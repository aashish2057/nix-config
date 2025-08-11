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
}
