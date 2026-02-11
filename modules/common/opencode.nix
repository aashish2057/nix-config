{
  pkgs,
  lib,
  username,
  opencode,
  isWork,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.opencode = {
        enable = true;
        package = opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings =
          {}
          // lib.optionalAttrs isWork {
            lsp.pyright.disabled = true;
            formatter = {
              ruff.disable = true;
              uv.disabled = true;
            };
            mcp.atlassian = {
              type = "remote";
              url = "https://mcp.atlassian.com/v1/mcp";
              enabled = true;
              oauth = {};
            };
          };
      };
    }
  ];
}
