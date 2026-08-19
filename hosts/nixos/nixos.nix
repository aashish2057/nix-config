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
    ../../modules/common/git.nix
    ../../modules/common/jujutsu.nix
    ../../modules/common/zsh.nix
    ../../modules/common/fish.nix
    ../../modules/common/fzf.nix
    ../../modules/common/starship.nix
    ../../modules/common/neovim/neovim.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/tmux.nix
    ../../modules/common/opencode.nix
    ../../modules/linux/fonts.nix
    ../../modules/linux/niri.nix
    ../../modules/linux/nvidia.nix
    ../../modules/linux/i18n.nix
    ../../modules/linux/xserver.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/pipewire.nix
    ../../modules/linux/mullvad.nix
    ../../modules/linux/awww.nix
    ../../modules/linux/sunsetr.nix
    ../../modules/linux/quickshell.nix
    ../../modules/linux/steam.nix
    ../../modules/linux/vicinae.nix
    ../../modules/linux/voxtype.nix
  ];

  system.stateVersion = "25.05";

  hardware.i2c.enable = true;

  # Keychron Launcher uses WebHID/WebUSB and needs access to the keyboard's
  # raw HID interface. Keep the permission scoped to Keychron and STM32 DFU.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="users", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d049", MODE="0660", GROUP="users", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users", TAG+="uaccess"
  '';

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
}
