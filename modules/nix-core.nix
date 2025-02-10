{
  lib,
  pkgs,
  system,
  username,
  homedir,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.neovim
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  # Needed for home manager see https://github.com/nix-community/home-manager/issues/6036
  users.users.${username}.home = homedir;
}
