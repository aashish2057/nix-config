{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/linux/sshd.nix
  ];

  system.stateVersion = "25.11";

  security.rtkit.enable = true;

  users.users.${username}.shell = pkgs.zsh;

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

  services.openssh.settings.PubkeyAuthentication = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
