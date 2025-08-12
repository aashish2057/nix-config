{
  pkgs,
  pkgs-unstable,
  lib,
  username,
  isWork,
  ...
}: {
  home-manager.users.${username} = {
    imports = [
      ./shell.nix
      ./starship.nix
    ];

    programs.home-manager.enable = true;

    home = {
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
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          pkgs.ghostty
          (pkgs.ungoogled-chromium.override {enableWideVine = true;})
          pkgs.git
          pkgs.ddcutil
          pkgs.btop
          pkgs.wl-clipboard
          pkgs.hyprpaper
          pkgs-unstable.hyprsunset

          (pkgs-unstable.opencode.overrideAttrs (oldAttrs: {
            version = "0.4.12";
            src = pkgs.fetchFromGitHub {
              owner = "sst";
              repo = "opencode";
              rev = "4580c88c0b38519e8187d2df1035e9538b51ec2a";
              sha256 = "19398lii5xsqhrs4jyk7v1djga3rd8wjzqxvqn66yj3g9qfip3yy";
            };

            tui = oldAttrs.tui.overrideAttrs {
              vendorHash = "sha256-jINbGug/SPGBjsXNsC9X2r5TwvrOl5PJDL+lrOQP69Q=";
            };

            node_modules = oldAttrs.node_modules.overrideAttrs {
              outputHash = "sha256-LmNn4DdnSLVmGS5yqLyk/0e5pCiKfBzKIGRvvwZ6jHY=";
            };
          }))
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
