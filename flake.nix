{
  description = "nix configuration by aashish2057";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
    nixosConfigurations = {
      nixos = systems.mkNixosSystem {
        hostname = "nixos";
        username = "aashishsharma";
        system = "x86_64-linux";
      };
    };
  };
}
