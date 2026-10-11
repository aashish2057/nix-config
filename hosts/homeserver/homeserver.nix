{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
  ];

  system.stateVersion = "25.11";

  networking.networkmanager.enable = true;

  security.rtkit.enable = true;

  users.users.${username}.shell = pkgs.zsh;

  services.tailscale.enable = true;

  fonts.packages = [pkgs.nerd-fonts.geist-mono];

  fonts.fontconfig = {
    enable = true;
    hinting.enable = true;
    defaultFonts = {
      monospace = ["Geist Mono"];
    };
  };

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
