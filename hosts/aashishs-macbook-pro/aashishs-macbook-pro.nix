{...}: {
  imports = [
    ../../modules/common/display-switch.nix
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/t3code.nix
  ];

  profiles.desktop.enable = true;

  agents = {
    claude = true;
    codex = true;
  };
}
