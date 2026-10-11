{...}: {
  imports = [
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/mise.nix
  ];

  profiles.desktop.enable = true;
}
