{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nix-core.nix
    ../../modules/system.nix
    ../../modules/homebrew.nix
  ];
}
