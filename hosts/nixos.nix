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
    ];
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
      ungoogled-chromium
      discord
      git
      ddcutil
      btop
      wl-clipboard
      hyprpaper
    ];
  };
}
