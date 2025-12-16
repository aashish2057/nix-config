{
  pkgs,
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
          pkgs.nh
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          pkgs.ungoogled-chromium
          pkgs.git
          pkgs.ddcutil
          pkgs.btop
          pkgs.wl-clipboard
          pkgs.hyprpaper
          pkgs.hyprsunset
          pkgs.prismlauncher
          pkgs.obsidian
          pkgs.gcc
          pkgs.gnumake
        ]
        ++ lib.optionals isWork [
          pkgs.lazydocker
          pkgs.azure-cli
          pkgs.kubectl
          pkgs.kubelogin
          pkgs.k9s
          pkgs.terraform
          pkgs.mprocs
          pkgs.kubernetes-helm
          pkgs.uv
          pkgs.ngrok
        ];
    };
  };
}
