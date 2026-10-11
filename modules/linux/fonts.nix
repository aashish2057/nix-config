{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    fonts.fontconfig = {
      enable = true;
      hinting.enable = true;
      defaultFonts = {
        monospace = ["Berkeley Mono"];
      };
    };
  };
}
