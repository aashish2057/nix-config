{
  pkgs,
  lib,
  username,
  ...
}: let
  t3 = (pkgs.callPackage ../../pkgs/t3code {}).server;
in {
  # Keep the user manager running without a login session.
  users.users.${username}.linger = true;

  home-manager.sharedModules = [
    {
      home.packages = [t3];

      # Mirrors the unit written by `t3 service install`, which pins a runtime
      # under ~/.t3/runtime that cannot run on NixOS.
      systemd.user.services.t3code = {
        Unit = {
          Description = "T3 Code server";
          StartLimitIntervalSec = 300;
          StartLimitBurst = 5;
        };
        Service = {
          Type = "simple";
          WorkingDirectory = "%h";
          # Provider CLIs and git must be on the server's PATH.
          Environment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin";
          ExecStart = "${lib.getExe t3} serve";
          KillMode = "mixed";
          OOMPolicy = "continue";
          Restart = "always";
          RestartSec = 5;
        };
        Install.WantedBy = ["default.target"];
      };
    }
  ];
}
