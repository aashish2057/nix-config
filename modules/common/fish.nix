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
          if set -q REX_BIN_DIR
              fish_add_path --move --path $REX_BIN_DIR
          end
        '';
        interactiveShellInit =
          ''
            set -g fish_greeting
            set -g fish_autocd 1
            set -gx OPENCODE_ENABLE_EXA 1
            source (COMPLETE=fish jj | psub)
            fish_add_path ~/.npm-global/bin
            fish_add_path /opt/homebrew/bin
          ''
          + lib.optionalString isWork ''
            direnv hook fish | source
          '';
      };
    }
  ];
}
