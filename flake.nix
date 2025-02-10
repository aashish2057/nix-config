{
  description = "Basic nix conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
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
    username = "aashishsharma";
    homedir = "/Users/${username}";
    hostname = "Aashishs-Macbook-Pro";

    specialArgs =
      inputs
      // {
        inherit system username homedir hostname;
      };

    configuration = {pkgs, ...}: {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
    };
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        ./modules/nix-core.nix
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit username homedir;
          };
          home-manager.users.${username} = import ./home.nix;
        }
      ];
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
