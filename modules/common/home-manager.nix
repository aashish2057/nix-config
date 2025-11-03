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
          pkgs-unstable.nh
          pkgs.nodejs_22
          pkgs-unstable.cargo
          pkgs-unstable.clippy
          pkgs-unstable.bun
          pkgs.direnv
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
          pkgs.kubernetes-helm
          pkgs-unstable.uv
        ];
    };
  };
}
