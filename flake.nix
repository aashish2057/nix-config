{
  description = "nix configuration by aashish2057";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw = {
      url = "github:Gerg-L/mnw";
    };

    opencode = {
      url = "github:sst/opencode";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nix-darwin,
    self,
    mnw,
    opencode,
    ...
  }: let
    systems = import ./lib/systems.nix {
      inherit nixpkgs home-manager nix-darwin self mnw opencode;
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

      homelab = systems.mkNixosSystem {
        hostname = "nixos";
        username = "homelab";
        system = "x86_64-linux";
      };
    };
  };
}
