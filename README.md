# nix-config
My nix config for macos


# Installation

These instructions should be run a fresh macos install. If you are not on a fresh macos install, these may not work for you.

Install the nix using the [Determinate Systems Installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#install-nix)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --determinate
```

Use nix shell to temporary access git and clone the repo
```bash
nix shell nixpkgs#git
git clone https://github.com/aashish2057/nix-config.git
```

Cd to the root of the repo, install and apply nix-darwin to the system
```bash
cd nix-config
nix run nix-darwin -- switch --flake .
darwin-rebuild switch --flake .
```
