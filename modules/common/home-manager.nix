{
  pkgs,
  pkgs-unstable,
  lib,
  username,
  isWork,
  ...
}: {
  home-manager.users.${username} = {
    programs.home-manager.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home = {
      file = lib.optionalAttrs pkgs.stdenv.isDarwin {
        ".hushlogin".text = "";
      };
      stateVersion = "25.05";
      packages =
        [
          pkgs.fzf
          pkgs.zsh-fzf-history-search
          pkgs.zsh-fzf-tab
          pkgs.ripgrep
          pkgs.alejandra
          pkgs.yazi
          pkgs-unstable.nh
          pkgs.nodejs_22
          (pkgs-unstable.opencode.overrideAttrs (oldAttrs: {
            version = "0.13.5";
            src = pkgs.fetchFromGitHub {
              owner = "sst";
              repo = "opencode";
              rev = "5345c828cac894a15f6347da681462bddfa8acf6";
              sha256 = "sha256-GiByJg4NpllA4N4QGSyWsBNqKqKIdxicIjQpc7mHgEs=";
            };

            tui = oldAttrs.tui.overrideAttrs {
              vendorHash = "sha256-H+TybeyyHTbhvTye0PCDcsWkcN8M34EJ2ddxyXEJkZI=";
            };

            node_modules = oldAttrs.node_modules.overrideAttrs {
              outputHash = "sha256-RHg55NvI52EGTWUCCJVrilXqr3qc+vqQoT/uIUjDVvg=";
            };
          }))
          pkgs-unstable.cargo
          pkgs-unstable.clippy
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          pkgs.ungoogled-chromium
          pkgs.git
          pkgs.ddcutil
          pkgs.btop
          pkgs.wl-clipboard
          pkgs.hyprpaper
          pkgs-unstable.hyprsunset
          pkgs.prismlauncher
          pkgs.obsidian
          pkgs.gcc
          pkgs.gnumake
        ]
        ++ lib.optionals isWork [
          pkgs.docker
          pkgs.colima
          pkgs.lazydocker
          # Work project is dotnet 8, roslyn lsp is dotnet 9
          (with pkgs.dotnetCorePackages;
            pkgs.dotnetCorePackages.combinePackages [
              sdk_8_0
              sdk_9_0
            ])
          pkgs.dotnet-ef
          pkgs.azurite
          pkgs.azure-cli
          pkgs.pnpm
          pkgs.kubectl
          pkgs.kubelogin
          pkgs.k9s
          pkgs.terraform
          pkgs-unstable.mprocs
        ];
    };
  };
}
