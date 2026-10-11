{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/t3code-server.nix
  ];

  system.stateVersion = "25.11";

  agents = {
    claude = true;
    codex = true;
  };

  networking.networkmanager.enable = true;

  users.users.${username}.shell = pkgs.fish;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      PubkeyAuthentication = true;
    };
  };
}
