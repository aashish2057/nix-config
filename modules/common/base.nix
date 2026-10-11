{...}: {
  imports = [
    ./nix-core.nix
    ./home-manager.nix
    ./desktop.nix
    ./agents.nix
    ./git.nix
    ./jujutsu.nix
    ./fish.nix
    ./fzf.nix
    ./starship.nix
    ./neovim/neovim.nix
    ./tmux.nix
  ];
}
