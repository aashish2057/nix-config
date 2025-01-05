# nix-config
My nix config for macos


### Install

These instructions should be run a fresh macos install. If you are not on a fresh macos install, these may not work for you.

Install the nix using the [Determinate Systems Installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#install-nix)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --determinate
```

Open a new terminal window and use [nix env shell](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-env-shell) to temporary access git and clone the repo
```bash
nix env shell nixpkgs#git
git clone https://github.com/aashish2057/nix-config.git
```

Disable nix.conf installed by Determinate Systems, doing so will disable experimental features like nix-command and flakes
```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

cd to the root of the repo, open flake.nix in your editor of choice and update `darwin.Configurations."<System Name>"` to your system name and then install [nix-darwin](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#step-1-creating-flakenix) to the system
use the --extra-experimental-features flag to enable nix-command and flakes since they are needed in the install
```bash
cd nix-config
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
```

Apply nix-darwin
```bash
darwin-rebuild switch --flake .
```


### Uninstall

Remove [nix-darwin](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#uninstalling)
```bash
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

Remove nix using [Determinate Systems Uninstalled](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#uninstalling)
```bash
/nix/nix-installer uninstall
```
