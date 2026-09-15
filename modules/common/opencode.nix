{
  lib,
  pkgs,
  username,
  isWork,
  ...
}: let
  baseSettings = {
    permission = {
      external_directory = {
        "$HOME/Dev/**" = "allow";
      };
      bash = {
        "terraform *" = "deny";
        "terraform fmt*" = "allow";
        "terraform init" = "allow";
        "terraform validate" = "allow";
        "terraform plan -lock=false" = "allow";
        "terraform import*" = "ask";
        "az *" = "ask";
        "az resource list*" = "allow";
        "az resource show*" = "allow";
      };
      websearch = "allow";
    };
    autoupdate = false;
  };

  workSettings = lib.optionalAttrs isWork {
    lsp = {
      pyright.disabled = true;
      csharp.command = [
        "Microsoft.CodeAnalysis.LanguageServer"
        "--stdio"
      ];
    };
    formatter = {
      ruff.disabled = true;
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
      slack = {
        type = "remote";
        url = "https://mcp.slack.com/mcp";
        enabled = true;
        oauth = {
          clientId = "1601185624273.8899143856786";
          redirectUri = "http://localhost:3118/callback";
        };
      };
    };
  };

  personalSettings =
    lib.optionalAttrs (!isWork) {
    };
in {
  home-manager.sharedModules = [
    {
      programs.opencode = {
        enable = true;
        # package = pkgs.callPackage ../../pkgs/opencode {};
        context = ./opencode/AGENTS.md;
        commands.review = ./opencode/review.md;
        tui.theme = "ayu";
        settings = lib.foldl' lib.recursiveUpdate {} [
          baseSettings
          workSettings
          personalSettings
        ];
      };
    }
  ];
}
