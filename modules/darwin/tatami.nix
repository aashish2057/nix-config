{pkgs, ...}: let
  tatami = pkgs.callPackage ../../pkgs/tatami {};
in {
  home-manager.sharedModules = [
    ({config, ...}: {
      home.packages = [tatami];

      xdg.configFile."tatami".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Dev/nix-config/modules/darwin/tatami";

      launchd.agents.tatami = {
        enable = true;
        config = {
          ProgramArguments = ["${tatami}/bin/tatami" "start"];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
          LimitLoadToSessionType = "Aqua";
          ProcessType = "Interactive";
          ThrottleInterval = 10;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/tatami.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/tatami.log";
        };
      };
    })
  ];
}
