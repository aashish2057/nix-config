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


          set -g status-right "#(date '+%H:%M') | #(date '+%Y-%m-%d')"
          set -g status-style "bg=#090E13,fg=#c5c9c7"

          set -g window-status-style "bg=#090E13,fg=#5C6066"
          set -g window-status-current-style "bg=#090E13,fg=#c5c9c7"

          set -g status-left-style "bg=#090E13,fg=#7fb4ca"
          set -g status-right-style "bg=#090E13,fg=#7fb4ca"
        '';
      };
    }
  ];
}
