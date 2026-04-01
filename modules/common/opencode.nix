{
  pkgs,
  lib,
  username,
  isWork,
  ...
}: {
  home-manager.sharedModules = [
    {
      programs.opencode = {
        enable = true;
        package = pkgs.opencode;
        rules = ./opencode/AGENTS.md;
        commands.review = ./opencode/review.md;
        settings =
          lib.recursiveUpdate {
            permission.external_directory = {
              "$HOME/Dev/**" = "allow";
            };
          }
          (lib.optionalAttrs isWork {
            permission = {
              bash = {
                "terraform *" = "deny";
                "terraform fmt*" = "allow";
                "terraform init" = "allow";
                "terraform validate" = "allow";
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
