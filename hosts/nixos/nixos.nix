{
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/core.nix
    ../../modules/common/fonts.nix
    ../../modules/linux/hyprland.nix
    ../../modules/linux/nvidia.nix
    ../../modules/linux/i18n.nix
    ../../modules/linux/xserver.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["i2c-dev"];

  hardware.i2c.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
}
