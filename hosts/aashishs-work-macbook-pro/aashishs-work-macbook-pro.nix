{...}: {
  imports = [
    ../../modules/common/display-switch.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/t3code.nix
    ../../modules/common/mise.nix
  ];

  profiles.desktop.enable = true;
}
