{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/obsidian-headless.nix
    ../../modules/linux/t3code-server.nix
  ];

  system.stateVersion = "25.11";

  agents = {
    claude = true;
    codex = true;
  };

  users.users.${username}.shell = pkgs.fish;
}
