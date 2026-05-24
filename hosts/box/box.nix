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
    ../../modules/common/fish.nix
    ../../modules/common/fzf.nix
    ../../modules/common/starship.nix
    ../../modules/common/neovim/neovim.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/tmux.nix
    ../../modules/linux/i18n.nix
    ../../modules/linux/boot.nix
  ];

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  nixpkgs.config.cudaSupport = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  system.stateVersion = "25.11";

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  services.tailscale.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.enable = true;

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
