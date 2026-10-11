{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    services = {
      mullvad-vpn = {
        enable = true;
        gui.enable = true;
      };
      resolved.enable = true;
    };
  };
}
