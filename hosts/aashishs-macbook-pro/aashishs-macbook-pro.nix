{...}: {
  imports = [
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
  ];

  profiles.desktop.enable = true;

  agents = {
    claude = true;
    codex = true;
  };
}
