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
    # ../../modules/common/git.nix
    ../../modules/common/shell.nix
    ../../modules/common/starship.nix
    ../../modules/common/neovim/neovim.nix
    ../../modules/common/ghostty.nix
    ../../modules/linux/fonts.nix
    # ../../modules/linux/hyprland.nix
    # ../../modules/linux/nvidia.nix
    ../../modules/linux/i18n.nix
    # ./../modules/linux/xserver.nix
    # ../../modules/linux/boot.nix
    # ../../modules/linux/pipewire.nix
    # ../../modules/linux/hyprland.nix
  ];

  system.stateVersion = "25.11";

  # hardware.i2c.enable = true;

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
