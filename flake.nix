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
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    systems = import ./lib/systems.nix {
      inherit nixpkgs nixpkgs-unstable home-manager self;
    };
  in {
    nixosConfigurations = {
      nixos = systems.mkNixosSystem {
        hostname = "nixos";
        username = "aashishsharma";
        system = "x86_64-linux";
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
