{
  pkgs,
  lib,
  username,
  isWork,
  ...
}: let
  # Build the cursor plugin from source and load it as a local `file://` plugin.
  # opencode's `isPathPluginSpec` routes any `file://` spec through
  # `resolvePathPluginTarget` (never `Npm.add`), which avoids the runtime npm
  # cache write that fails with EACCES on this machine. Bump `version` in
  # ./opencode/open-cursor.nix to update (pinned, not `@latest`).
  open-cursor = pkgs.callPackage ./opencode/open-cursor.nix {};

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
    plugin = ["file://${open-cursor}/lib/node_modules/@rama_nigg/open-cursor"];
    provider = {
      cursor-acp = {
        name = "Cursor ACP";
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "http://127.0.0.1:32124/v1";
        };
        models = {
          "cursor-acp/auto" = {name = "Auto";};
          "cursor-acp/claude-opus-4-8-high" = {name = "Claude 4.8 Opus";};
          "cursor-acp/gpt-5.5-medium" = {name = "GPT-5.5";};
          "cursor-acp/glm-5.2-high" = {name = "GLM 5.2";};
          "cursor-acp/composer-2.5" = {name = "Composer 2.5";};
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
        package = pkgs.opencode;
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
