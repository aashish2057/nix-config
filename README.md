# Nix config for macOS

### Overview
After learning about nix and it's philosophy I became curious about using it. I soon learned about Nix Darwin and how I could use Nix, Nix Packages a Nix Darwin to get a declarative setup on my mac. This configuration is what I use on my personal machine every day. It was a pain to learn but once I did, it has been a joy to use. If you are intrigued by Nix on Mac this is good place to start. Browse through the readme to learn a thing or two. While I recommend you create your own configuration as that is the best way to learn, you can certainly use mine, just know this configuration is meant to work with my system and hardware not be a general purpose configuration for mac so you may run into issues.
### Table of Contents
- [Nix config for macOS](#nix-config-for-macos)
	- [Overview](#overview)
	- [Table of Contents](#table-of-contents)
	- [Install](#install)
		- [Dependencies](#dependencies)
			- [Xcode](#xcode)
			- [Nix](#nix)
			- [Setting up the repository](#setting-up-the-repository)
			- [Nix-Darwin](#nix-darwin)
	- [Others](#others)
		- [Arc](#Arc)
		- [Wallpaper](#Wallpaper)
	- [Uninstall](#uninstall)
### Install
This configuration is meant for a Macbook Pro M2 running macOS Sonoma 14.6 and should be installed on a clean system. You will need to use the terminal to run the commands provided.
### Dependencies
#### Xcode
I originally was hoping I was going to be able to configure a system that didn't need Xcode clit tools however with the inclusion of [Homebrew](https://brew.sh/), this has to be included.
```Bash
xcode-select --install
```

#### Homebrew
I use [homebrew](https://brew.sh/) to install gui applications, as using nixpkgs for them isn't the best right now for macOS.
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Nix
Installing nix used to be a real pain, uninstalling was even worse. [Determinate Systems](https://determinate.systems/) has made this process seemless. As such we will be using the [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer) to install Nix. When you run the installer make sure to say no when it asks you if you want to install [Determinate Nix](https://docs.determinate.systems/determinate-nix) which is Determinate's downstream Nix distribution you say no. This leads to problems later on with Nix Darwin that we want to avoid.
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```
#### Setting up the repository
At this point you should have access to git on your system, which was installed when you installed Xcode cli tools. If you want to use this repository clone the repo. **Make sure you keep note of where you cloned the repo it will be important later**

```bash
git clone https://github.com/aashish2057/nix-config.git
```

There are a couple areas inside the repository you will need to change to match your system/settings. Open the repository in your editor of choice and edit the following. Each code block will have the file path at the top. The first two are so that Nix Darwin and Home Manager know the username of your user and the hostname of the machine to install on.
```bash
# flake.nix
username = "aashishsharma"; # line 26
hostname = "Aashishs-MacBook-Pro"; # line 28
```

The next two are your git username and email. You can get these from a machine you already have git setup with by executing the commands in the double quotes.
```bash
# home/git.nix
userName = "aashishsharma"; # line 5
userEmail = "aashish2057@gmail.com"; # line 6
```

Lastly, remember when I told you to keep track of where you cloned the repo. Now make sure this path to your repo is correct. The repo is setup as if you cloned the repository in `/Desktop`.
```Bash
# home/core.nix
source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dev/nix-config/dotfiles/ghostty"; # line 52
source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dev/nix-config/dotfiles/nvim"; # line 55
```
This allows you to access your configuration in neovim regardless of where you opened neovim. This makes it easy to make quit edits to your configuration.
```lua
-- dotfiles/nvim/lua/config/core/keymaps
cwd = vim.fn.expand("~/Dev/nix-config"),
```
#### Nix-Darwin
Now you are ready to install [Nix Darwin](https://github.com/LnL7/nix-darwin). At this point be sure that you want to proceed this could override your mac settings, program settings etc.

Disable nix.conf installed by Determinate Systems, doing so will disable experimental features like nix-command and flakes. We do this as Nix Darwin will be creating a new nix.conf based on the configuration in the repo.
```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

Run this command from the directory containing your flake.nix file. This will install any inputs such as Nix Darwin from the flake and a build the system based on your configuration.
```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
```

Now that you have install Nix Darwin you can just use the command below anytime you want to rebuild your system after making changes to your flakes.
```bash
darwin-rebuild switch --flake .
```

### Others

#### Arc
Custom shortcuts for Arc Browser\
achieve tab - `ctrl - w`\
find - `ctrl - f`\
go back - `ctrl + shift - left`\
go forward - `ctrl + shift - right`\
new tab - `ctrl - t`\
new window - `ctrl - n`\
next space - `ctrl + cmd - right`\
prev space - `ctrl + cmd - left`\
next tab - `ctrl + cmd - up`\
next tab - `ctrl + cmd - down`\
open command bar - `ctrl + shift - l`\
refresh the page - `ctrl + r`\
restore last closed tab - `ctrl + shift - t`\
show/hide sidebar - `ctrl - s`

#### Wallpaper
1. settings > screensaver > select the one with the highways/traffic
2. Go > Computer > macHD > Library > application support > com .apple.idleassetsd > Customer > 4KSDR240FPS 
3. delete 35693AEA-F8C4-4A80-B77D-C94B20A68956 .mov 
4. drop in file

### Uninstall
Uninstall all casks from homebrew. This gets rid of the cask and the user data
```bash
brew list --cask | xargs brew uninstall --zap --cask
```

Uninstall homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

Remove [nix-darwin](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#uninstalling)
```bash
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

Remove nix using [Determinate Systems](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#uninstalling)
```bash
/nix/nix-installer uninstall
```

Clean up any nix remnants, there will still be a /nix folder that doesn't contain anything.
```bash
sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
rm -rf ~/.nixpkgs
```
