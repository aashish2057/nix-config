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
            version = "0.5.8";
            src = pkgs.fetchFromGitHub {
              owner = "sst";
              repo = "opencode";
              rev = "c3c440948a3361a537f0855fe95f11bfab3590d4";
              sha256 = "0pycsmkgrd59d9c0q4cz5b45bv4j9kz06xrwv5n7bbmf5wzzj328";
            };

            tui = oldAttrs.tui.overrideAttrs {
              vendorHash = "sha256-acDXCL7ZQYW5LnEqbMgDwpTbSgtf4wXnMMVtQI1Dv9s=";
            };

            node_modules = oldAttrs.node_modules.overrideAttrs {
              outputHash =
                if pkgs.stdenv.isLinux
                then "sha256-hznCg/7c9uNV7NXTkb6wtn3EhJDkGI7yZmSIA2SqX7g="
                else "sha256-/s6eAI1VJ0kXrxP5yTi+jwNqHBCRcoltJC86AT7nVdI=";
            };
          }))
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
        ];
    };
  };
}
