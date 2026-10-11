{
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/common/nix-core.nix
    ../../modules/common/home-manager.nix
    ../../modules/common/agents.nix
    ../../modules/common/git.nix
    ../../modules/common/jujutsu.nix
    ../../modules/common/fish.nix
    ../../modules/common/fzf.nix
    ../../modules/common/starship.nix
    ../../modules/common/neovim/neovim.nix
    ../../modules/common/tmux.nix
    ../../modules/linux/i18n.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/t3code-server.nix
  ];

  system.stateVersion = "25.11";

  agents = {
    claude = true;
    codex = true;
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      PubkeyAuthentication = true;
    };
  };
}
