{pkgs, ...}: {
  home-manager.sharedModules = [
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        prefix = "C-Space";
        shell = "${pkgs.zsh}/bin/zsh";
        extraConfig = ''
          set-option -sa terminal-overrides ",xterm*:Tc"
          set-option -g default-command "${pkgs.zsh}/bin/zsh -l"

          bind -n S-Left  previous-window
          bind -n S-Right next-window

          set -g status-bg "#0F111A"
          set -g status-right "#(date '+%H:%M') | #(date '+%Y-%m-%d')"
        '';
      };
    }
  ];
}
