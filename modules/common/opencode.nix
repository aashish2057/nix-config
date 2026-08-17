{
  pkgs,
  lib,
  username,
  isWork,
  ...
}: let
  agentBrowser = pkgs.callPackage ../../pkgs/agent-browser {};
  helium = pkgs.callPackage ../../pkgs/helium {};

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
  };

  personalSettings =
    lib.optionalAttrs (!isWork) {
    };
in {
  home-manager.sharedModules = [
    {
      home.sessionVariables = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe helium;
      };

      programs.opencode = {
        enable = true;
        package = pkgs.opencode;
        extraPackages = [agentBrowser];
        skills.agent-browser = "${agentBrowser}/skills/agent-browser";
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
