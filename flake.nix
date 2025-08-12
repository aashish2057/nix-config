{
  description = "nix configuration by aashish2057";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    systems = import ./lib/systems.nix {
      inherit nixpkgs nixpkgs-unstable home-manager;
    };
  in {
    darwinConfigurations = {
      Aashishs-MacBook-Pro = systems.mkDarwinSystem {
        hostname = "aashishs-macbook-pro";
        username = "aashishsharma";
        system = "aarch64-darwin";
      };

      Aashishs-Work-MacBook-Pro = systems.mkDarwinSystem {
        hostname = "aashishs-work-macbook-pro";
        username = "aashishsharmawork";
        system = "aarch64-darwin";
        isWork = true;
      };
    };

    nixosConfigurations = {
      nixos = systems.mkNixosSystem {
        hostname = "nixos";
        username = "aashishsharma";
        system = "x86_64-linux";
      };
    };
  };
}
