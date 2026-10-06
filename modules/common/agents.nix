{
  config,
  isWork,
  lib,
  system,
  ...
}: let
  cfg = config.agents;

  sharedContext = ./agents/AGENTS.md;
  sharedSkills = {
    review = ./agents/review;
    testing = ./agents/testing;
  };

  opencodeSettings =
    {
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
    }
    // lib.optionalAttrs isWork {
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
    };

  mcpServers = lib.optionalAttrs isWork {
    atlassian = {
      url = "https://mcp.atlassian.com/v1/mcp";
      enabled = true;
      oauth = {};
    };
    datadog = {
      url = "https://mcp.us3.datadoghq.com/api/unstable/mcp-server/mcp";
      enabled = true;
      oauth = {};
    };
    notion = {
      url = "https://mcp.notion.com/mcp";
      enabled = true;
      oauth = {};
    };
    slack = {
      url = "https://mcp.slack.com/mcp";
      enabled = true;
      oauth = {
        clientId = "1601185624273.8899143856786";
        redirectUri = "http://localhost:3118/callback";
      };
    };
  };

  oauthFieldNames = {
    clientId = "client_id";
    clientSecret = "client_secret";
    callbackPort = "callback_port";
    redirectUri = "redirect_uri";
  };
  opencodeMcpServers =
    lib.mapAttrs (_: server:
      {
        type = "remote";
        inherit (server) url;
      }
      // lib.optionalAttrs (server.oauth != {}) {
        oauth = lib.mapAttrs' (name: lib.nameValuePair (oauthFieldNames.${name} or name)) server.oauth;
      })
    mcpServers;
in {
  options.agents = {
    opencode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable OpenCode.";
    };

    cursor = lib.mkOption {
      type = lib.types.bool;
      default = isWork;
      defaultText = lib.literalExpression "isWork";
      description = "Whether to enable Cursor and Cursor Agent.";
    };

    claude = lib.mkEnableOption "Claude Code";
    codex = lib.mkEnableOption "Codex";
  };

  config =
    {
      home-manager.sharedModules = [
        ({pkgs, ...}: let
          jsonFormat = pkgs.formats.json {};
          cursorMcpServers = lib.mapAttrs (_: server: removeAttrs server ["enabled" "oauth"]) mcpServers;
          cursorRule = pkgs.writeText "shared-agent-context.mdc" ''
            ---
            alwaysApply: true
            ---

            ${builtins.readFile sharedContext}
          '';
        in {
          programs = {
            mcp = {
              enable = true;
              servers = mcpServers;
            };

            opencode = lib.mkIf cfg.opencode {
              enable = true;
              package = pkgs.callPackage ../../pkgs/opencode {};
              context = sharedContext;
              skills = sharedSkills;
              tui.theme = "ayu";
              settings =
                opencodeSettings
                // lib.optionalAttrs (opencodeMcpServers != {}) {
                  mcp.servers = opencodeMcpServers;
                };
            };

            claude-code = lib.mkIf cfg.claude {
              enable = true;
              package = pkgs.callPackage ../../pkgs/claude-code {};
              enableMcpIntegration = true;
              context = sharedContext;
              skills = sharedSkills;
            };

            codex = lib.mkIf cfg.codex {
              enable = true;
              package = pkgs.callPackage ../../pkgs/codex {};
              enableMcpIntegration = true;
              context = sharedContext;
              skills = sharedSkills;
              settings.check_for_update_on_startup = false;
            };
          };

          home.file = lib.mkIf cfg.cursor (
            {
              ".cursor/rules/shared-context.mdc".source = cursorRule;
              ".cursor/mcp.json".source = jsonFormat.generate "cursor-mcp.json" {
                mcpServers = cursorMcpServers;
              };
            }
            // lib.mapAttrs' (name: source:
              lib.nameValuePair ".cursor/skills/${name}" {
                inherit source;
                recursive = true;
              })
            sharedSkills
          );
        })
      ];
    }
    // lib.optionalAttrs (lib.hasSuffix "-darwin" system) {
      homebrew.casks = lib.optionals cfg.cursor [
        "cursor"
        "cursor-cli"
      ];
    };
}
