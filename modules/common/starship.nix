{
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        settings =
          lib.recursiveUpdate
          (builtins.fromTOML (builtins.readFile
              "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"))
          {
            format = " $all";
            command_timeout = 1000;
            line_break.disabled = true;

            custom.jj = {
              when = "jj-starship detect";
              shell = ["jj-starship"];
              format = "$output ";
            };

            # jj-starship shows Git and jj info, so hide starship's git modules.
            git_branch.disabled = true;
            git_commit.disabled = true;
            git_state.disabled = true;
            git_metrics.disabled = true;
            git_status.disabled = true;

            gcloud.detect_env_vars = ["STARSHIP_SHOW_GCLOUD"];

            nix_shell = {
              symbol = "";
              impure_msg = "";
              heuristic = true;
            };
          };
      };
    }
  ];
}
