{
  description = "nix configuration by aashish2057";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    ...
  }: let
    systems = import ./lib/systems.nix {
      inherit nixpkgs nix-darwin home-manager self;
    };
  in {
    darwinConfigurations = {
      Aashishs-MacBook-Pro = systems.mkDarwinSystem {
        hostname = "aashishs-macbook-pro";
        username = "aashishsharma";
      };

      Aashishs-Work-MacBook-Pro = systems.mkDarwinSystem {
        hostname = "aashishs-work-macbook-pro";
        username = "aashishsharmawork";
      };
    };

    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
  };
}
