{
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  hardware.i2c.enable = true;
  boot.kernelModules = ["i2c-dev"];

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = false;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.printing.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
  ];

  fonts.fontconfig = {
    enable = true;
    hinting.enable = true;
    defaultFonts = {
      monospace = ["Geist Mono"];
    };
  };

  system.stateVersion = "25.05";
}
