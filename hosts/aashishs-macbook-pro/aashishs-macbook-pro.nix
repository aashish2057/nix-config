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
    ../../modules/common/git.nix
    ../../modules/common/shell.nix
    ../../modules/common/starship.nix
    ../../modules/common/neovim/neovim.nix
    ../../modules/common/ghostty.nix
    ../../modules/darwin/darwin.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/aerospace.nix
  ];
}
