{
  system,
  username,
  homedir,
  ...
}: {
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["root" username];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nixpkgs.hostPlatform = system;
  # Needed for home manager see https://github.com/nix-community/home-manager/issues/6036
  users.users.${username}.home = homedir;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
}
