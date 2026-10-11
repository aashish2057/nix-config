{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/linux/fonts.nix
  ];

  system.stateVersion = "25.11";

  networking.networkmanager.enable = true;

  security.rtkit.enable = true;

  users.users.${username}.shell = pkgs.zsh;

  services.tailscale.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = username;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      PubkeyAuthentication = false;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
