{
  pkgs,
  lib,
  username,
  ...
}: let
  # Relative to the home directory.
  vault = "Dev/obsidian";
in {
  # Keep the user manager running without a login session.
  users.users.${username}.linger = true;

  home-manager.sharedModules = [
    {
      home.packages = [pkgs.obsidian-headless];

      systemd.user.services.obsidian-sync = {
        Unit = {
          Description = "Obsidian Sync for ~/${vault}";
          # Stays inactive until `ob login` and `ob sync-setup` have been run.
          ConditionPathExists = [
            "%h/.config/obsidian-headless/auth_token"
            "%h/${vault}"
          ];
          StartLimitIntervalSec = 300;
          StartLimitBurst = 5;
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.obsidian-headless} sync --continuous --path %h/${vault}";
          Restart = "on-failure";
          RestartSec = 30;
        };
        Install.WantedBy = ["default.target"];
      };
    }
  ];
}
