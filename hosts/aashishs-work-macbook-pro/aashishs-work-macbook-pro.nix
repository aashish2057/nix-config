{
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ../../modules/common/nix-core.nix
    ../../modules/common/home-manager.nix
    ../../modules/common/fonts.nix
    ../../modules/common/git.nix
    ../../modules/common/shell.nix
    ../../modules/common/starship.nix
    ../../modules/darwin/darwin.nix
    ../../modules/darwin/homebrew.nix
  ];
}
