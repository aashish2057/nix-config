{
  lib,
  pkgs,
  system,
  username,
  homedir,
  ...
}: {
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.hostPlatform = system;

  # Needed for home manager see https://github.com/nix-community/home-manager/issues/6036
  users.users.${username}.home = homedir;
}
