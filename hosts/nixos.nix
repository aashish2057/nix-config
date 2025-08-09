{
  config,
  pkgs,
  pkgs-unstable,
  system,
  username,
  homedir,
  ...
}: {
  imports = [
    ./hardware.nix
    ../modules/nixos.nix
  ];

  users.users.${username}.home = homedir;

  home-manager.users.${username} = {
    pkgs,
    pkgs-unstable,
    config,
    username,
    homedir,
    ...
  }: {
    imports = [
      ../home/git.nix
      ../home/shell.nix
      ../home/starship.nix
    ];
    programs.home-manager.enable = true;

    home.stateVersion = "25.05";

    programs.git = {
      userName = "aashish2057";
      userEmail = "aashish2057@gmail.com";
    };

    home.sessionVariables = {
      EDITOR = "nixvim";
      MANPAGER = "nixvim +Man!";
    };

    home.packages = with pkgs; [
      ghostty
      (ungoogled-chromium.override {enableWideVine = true;})
      discord
      git
      ddcutil
      btop
      wl-clipboard
      hyprpaper
      fzf
      zsh-fzf-history-search
      zsh-fzf-tab
      ripgrep
      alejandra

      (opencode.overrideAttrs (oldAttrs: {
        version = "0.4.2";
        src = fetchFromGitHub {
          owner = "sst";
          repo = "opencode";
          rev = "7bbc643600a8a669f4dd9136a29f220a5b0e81ab";
          sha256 = "1jn274p5396p9y1miylac68pqyl8ilaf5rm0f0jjrf26yr0yd9gj";
        };

        tui = oldAttrs.tui.overrideAttrs {
          vendorHash = "sha256-jGaTgKyAvBMt8Js5JrPFUayhVt3QhgyclFoNatoHac4=";
        };

        node_modules = oldAttrs.node_modules.overrideAttrs {
          outputHash = "sha256-LmNn4DdnSLVmGS5yqLyk/0e5pCiKfBzKIGRvvwZ6jHY=";
        };
      }))
    ];
  };
}
