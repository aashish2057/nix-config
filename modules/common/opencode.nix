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
      xdg.configFile."opencode/AGENTS.md".text = ''
        # Jujutsu Workflow

        - NEVER use git unless jj has no way to do the thing. Always use jj. jj status, jj diff, jj diff -r @-, jj log, etc. to view a file at a revision, use `jj file show <path> -r <rev>` (not `jj cat`). to exclude paths from a jj command, use fileset syntax: `jj diff '~dir1 & ~dir2'` or `jj restore '~package-lock.json'`
        - prefer squash workflow in jj over editing, where if you're trying to update rev A, work in a rev on top of A and periodically squash what you've done into A
        - for parallel approaches, use `jj new <base>` to create siblings from a common base, implement each approach, then compare. bookmarks are unnecessary for this workflow
        - Non-destructive jj operations are generally allowlisted. When working on a complex change, use `jj new` or `jj commit` (equiv do jj desc + jj new) after chunks of work to snapshot each step in a reviewable way
        - when using `jj squash`, avoid the editor popup with `-m 'msg'` or `-u` to keep the destination message. These flags are mutually exclusive.
        - don't try to run destructive `jj` ops like squash or abandon unprompted. intermediate commits are fine; just note when cleanup might be needed
      '';

      programs.opencode = {
        enable = true;
        package = opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings =
          lib.recursiveUpdate {}
          (lib.optionalAttrs isWork {
            permission = {
              bash = {
                "terraform *" = "deny";
                "terraform fmt*" = "allow";
                "terraform init" = "allow";
                "terraform plan -lock=false" = "allow";
              };
            };
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
            mcp.datadog = {
              type = "remote";
              url = "https://mcp.us3.datadoghq.com/api/unstable/mcp-server/mcp";
              enabled = true;
              oauth = {};
            };
          });
      };
    }
  ];
}
