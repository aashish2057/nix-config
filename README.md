# nix-config
My nix config for macos


### Install

These instructions should be run a fresh macos install. If you are not on a fresh macos install, these may not work for you.

Install the nix using the [Determinate Systems Installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#install-nix), make sure to say no when the installer asks to use determinate-nix
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

Install xcode-cli-tools, needed for homebrew
```
xcode-select --install
```

Clone the repo
```bash
git clone https://github.com/aashish2057/nix-config.git
```

Disable nix.conf installed by Determinate Systems, doing so will disable experimental features like nix-command and flakes
```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

cd to the root of the repo, open flake.nix in your editor of choice and update the following variables
```bash
# user specific variables
system = "aarch64-darwin";
username = "whoami";
homedir = "/Users/${username}";
hostname = "echo $HOST";
```

cd to home and open git.nix in your editor of choice and update the following variables
```bash
# user specific variables
userName = "__git config user.name__";
userEmail = "__git config user.email__";
```

Install [nix-darwin](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#getting-started) to the system
use the --extra-experimental-features flag to enable nix-command and flakes since they are needed in the install
```bash
cd nix-config
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
```

When you make changes and want to rebuild the configuration use the following
```bash
darwin-rebuild switch --flake .
```


### Uninstall

Remove [nix-darwin](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#uninstalling)
```bash
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

Remove nix using [Determinate Systems](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#uninstalling)
```bash
/nix/nix-installer uninstall
```
