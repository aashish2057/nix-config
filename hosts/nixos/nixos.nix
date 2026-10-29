{...}: {
  imports = [
    ./hardware.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/ssh.nix
    ../../modules/linux/nvidia.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/t3code-server.nix
  ];

  profiles.desktop.enable = true;

  # Run headless: GDM would otherwise suspend the machine at the login screen.
  services.displayManager.gdm.autoSuspend = false;

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
}
