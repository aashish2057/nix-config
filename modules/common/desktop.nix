{lib, ...}: {
  imports = [
    ./display-switch.nix
    ./t3code.nix
  ];

  options.profiles.desktop.enable = lib.mkEnableOption "desktop machines (browser and GUI apps)";
}
