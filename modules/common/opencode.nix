{
  pkgs,
  lib,
  username,
  opencode,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.opencode = {
        enable = true;
        package = opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = {
          lsp.pyright.disabled = true;
        };
      };
    }
  ];
}
