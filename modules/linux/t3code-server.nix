{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  t3code = pkgs.callPackage ../../pkgs/t3code {};
  t3 = t3code.server;

  # Only one T3 server can own a data directory. The service below owns ~/.t3,
  # so the desktop app keeps its own local backend in ~/.t3-desktop and reaches
  # the service as a remote connection.
  t3codeDesktop = pkgs.symlinkJoin {
    name = "t3code-${t3code.version}";
    paths = [t3code];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/t3code \
        --run 'export T3CODE_HOME="''${T3CODE_HOME:-$HOME/.t3-desktop}"'
    '';
    inherit (t3code) meta passthru;
  };
in {
  # Keep the user manager running without a login session.
  users.users.${username}.linger = true;

  home-manager.sharedModules = [
    {
      home.packages = [t3];

      programs.t3code.package = lib.mkIf config.profiles.desktop.enable t3codeDesktop;

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
