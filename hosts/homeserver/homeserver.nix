{
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/nix-core.nix
    ../../modules/common/home-manager.nix
    ../../modules/common/shell.nix
    ../../modules/common/starship.nix
    ../../modules/common/neovim/neovim.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/tmux.nix
    ../../modules/linux/fonts.nix
    ../../modules/linux/i18n.nix
  ];

  system.stateVersion = "25.11";

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

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
