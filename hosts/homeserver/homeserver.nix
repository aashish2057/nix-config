{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./omnios-vm.nix
    ../../modules/linux/sshd.nix
  ];

  system.stateVersion = "25.11";

  services.openssh.settings.PubkeyAuthentication = false;

  # Lets SSH sessions from Ghostty use its terminal type.
  environment.systemPackages = [pkgs.ghostty.terminfo];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
