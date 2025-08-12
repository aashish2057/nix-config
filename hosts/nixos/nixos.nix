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
    ../../modules/common/fonts.nix
    ../../modules/common/git.nix
    ../../modules/linux/hyprland.nix
    ../../modules/linux/nvidia.nix
    ../../modules/linux/i18n.nix
    ../../modules/linux/xserver.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/pipewire.nix
  ];

  hardware.i2c.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
}
