{
  description = "Basic nix conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    # user specific variables
    system = "aarch64-darwin";
    username = "__whoami__";
    homedir = "/Users/${username}";
    hostname = "__$echo HOST__";

    specialArgs =
      inputs
      // {
        inherit system username homedir hostname;
      };
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/homebrew.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit username homedir;
          };
          home-manager.users.${username} = import ./home;
        }
      ];
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
