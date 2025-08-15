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
          (pkgs-unstable.opencode.overrideAttrs (finalAttrs: previousAttrs: {
            version = "0.4.41";
            src = pkgs.fetchFromGitHub {
              owner = "sst";
              repo = "opencode";
              rev = "93102dc84bc1ca944502d5a1476d8ee291b18f95";
              sha256 = "0irirq8sq4ix50w6f6gx89qs3x7vhkykb67sgr05d7j5zyxwwcvl";
            };

            node_modules = previousAttrs.node_modules.overrideAttrs (nmPrev: {
              outputHash =
                if pkgs.stdenv.isLinux
                then "sha256-ql4qcMtuaRwSVVma3OeKkc9tXhe21PWMMko3W3JgpB0="
                else "sha256-/s6eAI1VJ0kXrxP5yTi+jwNqHBCRcoltJC86AT7nVdI=";
            });

            nativeBuildInputs =
              previousAttrs.nativeBuildInputs
              ++ [
                pkgs.makeBinaryWrapper
              ];

            tui = previousAttrs.tui.overrideAttrs (tuiPrev: {
              modRoot = "packages/tui";
              vendorHash = "sha256-/BI9vBMSJjt0SHczH8LkxxWC2hiPPKQwfRhmf2/8+TU=";
            });

            buildPhase = ''
              runHook preBuild

              bun build \
                --define OPENCODE_TUI_PATH="'${finalAttrs.tui}/bin/tui'" \
                --define OPENCODE_VERSION="'${finalAttrs.version}'" \
                --compile \
                --target=bun-linux-x64 \
                --outfile=opencode \
                ./packages/opencode/src/index.ts \

              runHook postBuild
            '';

            # Fix for dynamic linking issue on Linux
            postFixup = lib.optionalString pkgs.stdenv.isLinux ''
              wrapProgram $out/bin/opencode \
                --set LD_LIBRARY_PATH "${lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib]}"
            '';
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
