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
        rules = ./opencode/AGENTS.md;
        commands.review = ./opencode/review.md;
        settings =
          lib.recursiveUpdate {}
          (lib.optionalAttrs isWork {
            permission = {
              bash = {
                "terraform *" = "deny";
                "terraform fmt*" = "allow";
                "terraform init" = "allow";
                "terraform plan -lock=false" = "allow";
                "terraform import*" = "ask";
              };
            };
            lsp.pyright.disabled = true;
            formatter = {
              ruff.disable = true;
              uv.disabled = true;
            };
            mcp = {
              atlassian = {
                type = "remote";
                url = "https://mcp.atlassian.com/v1/mcp";
                enabled = true;
                oauth = {};
              };
              datadog = {
                type = "remote";
                url = "https://mcp.us3.datadoghq.com/api/unstable/mcp-server/mcp";
                enabled = true;
                oauth = {};
              };
              notion = {
                type = "remote";
                url = "https://mcp.notion.com/mcp";
                enabled = true;
                oauth = {};
              };
            };
          });
      };
    }
  ];
}
