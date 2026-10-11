{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/ssh.nix
    ../../modules/linux/nvidia.nix
    ../../modules/linux/boot.nix
  ];

  profiles.desktop.enable = true;

  system.stateVersion = "25.05";

  agents = {
    claude = true;
    codex = true;
  };

  hardware = {
    i2c.enable = true;
    xone.enable = true;
  };

  # Keychron Launcher uses WebHID/WebUSB and needs access to the keyboard's
  # raw HID interface. Keep the permission scoped to Keychron and STM32 DFU.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="users", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d049", MODE="0660", GROUP="users", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users", TAG+="uaccess"
  '';

  networking.networkmanager.enable = true;

  users.users.${username}.shell = pkgs.zsh;

  services.tailscale.enable = true;
}
