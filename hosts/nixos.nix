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
      obsidian

      (pkgs-unstable.opencode.overrideAttrs (oldAttrs: {
        version = "0.4.12";
        src = fetchFromGitHub {
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
      pkgs-unstable.hyprsunset
    ];
  };
}
