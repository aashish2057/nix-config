{pkgs, ...}: {
  home-manager.sharedModules = [
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        prefix = "C-Space";
        shell = "${pkgs.zsh}/bin/zsh";
        extraConfig = ''
          # Address vim mode switching delay (http://superuser.com/a/252717/65504)
          set -s escape-time 0

          # Increase scrollback buffer size from 2000 to 50000 lines
          set -g history-limit 50000

          # Increase tmux messages display duration from 750ms to 4s
          set -g display-time 4000

          # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
          set -g status-interval 5

          # Upgrade $TERM
          set -g default-terminal "screen-256color"

          # Enable extended keys (CSI u encoding) for proper modifier key support
          # Allows Shift+Enter, Ctrl+Shift+<key>, etc. to work correctly in apps
          set -s extended-keys on
          set -as terminal-features 'xterm*:extkeys'

          # Emacs key bindings in tmux command prompt (prefix + :) are better than
          # vi keys, even for vim users
          set -g status-keys emacs

          # Focus events enabled for terminals that support them
          set -g focus-events on

          # Super useful when using "grouped sessions" and multi-monitor setup
          setw -g aggressive-resize on

          # Enable mouse support
          set -g mouse on

          set-option -sa terminal-overrides ",xterm*:Tc"
          set-option -g default-command "${pkgs.zsh}/bin/zsh -l"

          bind -n S-Left  previous-window
          bind -n S-Right next-window
          bind x kill-pane

          unbind %
          unbind '"'
          bind \\ split-window -h -c "#{pane_current_path}"  # Backslash for horizontal split
          bind Enter split-window -v -c "#{pane_current_path}"        # Enter for vertical split
          bind c new-window -c "#{pane_current_path}"                 # New window in current path

          # Status bar positioning
          set-option -g status-position top

          set -g status-right "#(date '+%H:%M') | #(date '+%Y-%m-%d')"
          set -g status-left-length 100

          set -g status-style "bg=#0F111A,fg=#A6ACCD"

          set -g status-left-style "bg=#0F111A,fg=#84FFFF"
          set -g status-right-style "bg=#0F111A,fg=#717CB4"

          set -g window-status-style "bg=#0F111A,fg=#464B5D"
          set -g window-status-current-style "bg=#0F111A,fg=#EEFFFF"
        '';
      };
    }
  ];
}
