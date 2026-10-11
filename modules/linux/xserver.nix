{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
  };
}
