## Credits
This repo wouldn't have been possible without the following folks making their configuration public. If you are looking to learn nix I recommend checking their repos out as they are much better than me. The many great people over at the Nix/NixOS discord were also critical in me making it this far, considering joining and contributing. There are likely others that I have forgotten to add that were all important in me getting this far.  
[@RGBCube](https://github.com/RGBCube) - [ncc](https://github.com/RGBCube/ncc/tree/master)  
[@mitchellh](https://github.com/mitchellh) - [nixos-config](https://github.com/mitchellh/nixos-config)  
[@NotAShelf](https://github.com/NotAShelf) - [nyx](https://github.com/NotAShelf/nyx)  
[@ryan4yin](https://github.com/ryan4yin) - [nixos-and-flakes-book](https://github.com/ryan4yin/nixos-and-flakes-book)  

## Overview
```
nix-config
├─ lib
│  └─ system.nix
├─ modules
│  ├─ common
│  │  ├─ nvim
│  │  ├─ shell.nix
│  │  ├─ git.nix
│  │  └─ starship.nix
│  ├─ darwin
│  │  ├─ aerospace
│  │  ├─ macos.nix
│  │  └─ homebrew.nix
│  └─ linux
├─ hosts
│  ├─ aashishs-macbook-pro.nix
│  ├─ aashishs-work-macbook-pro.nix
│  └─ nixos-desktop.nix
└─ flake.nix
```
