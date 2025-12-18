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
    ../../modules/linux/fonts.nix
    ../../modules/linux/i18n.nix
  ];

  system.stateVersion = "25.11";

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  networking.firewall = {
    allowedTCPPorts = [8096]; # Jellyfin HTTP
    allowedUDPPorts = [1900 7359]; # Service discovery
    # Or if you want to restrict to Tailscale only:
    # interfaces.tailscale0.allowedTCPPorts = [ 8096 ];
    # interfaces.tailscale0.allowedUDPPorts = [ 1900 7359 ];
  };

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
