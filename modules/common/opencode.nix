{
  pkgs,
  lib,
  username,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.opencode = {
        enable = true;
        package = pkgs.opencode;
        settings = {
          lsp.pyright.disabled = true;
        };
      };
    }
  ];
}
