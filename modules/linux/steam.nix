{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.profiles.desktop.enable {
    programs.steam.enable = true;
  };
}
