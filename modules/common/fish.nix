{
  lib,
  isWork,
  ...
}: {
  programs.fish.enable = true;

  home-manager.sharedModules = [
    {
      programs.fish = {
        enable = true;
        shellInit = ''
          fish_add_path --global /opt/homebrew/bin
          if set -q REX_BIN_DIR
              fish_add_path --move --path $REX_BIN_DIR
          end
        '';
        interactiveShellInit =
          ''
            set -g fish_greeting
            set -g fish_autocd 1
            source (COMPLETE=fish jj | psub)
            fish_add_path ~/.npm-global/bin
          ''
          + lib.optionalString isWork ''
            direnv hook fish | source
          '';
      };
    }
  ];
}
