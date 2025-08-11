{
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  home-manager,
  self,
}: {
  mkDarwinSystem = {
    hostname,
    username,
    system,
  }:
    nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit username self system;
        homedir = "/Users/${username}";
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
      modules = [
        ../hosts/${hostname}.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit username;
            homedir = "/Users/${username}";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
        }
      ];
    };

  mkNixosSystem = {
    hostname,
    username,
    system,
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit username self hostname system;
        homedir = "/home/${username}";
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
      modules = [
        ../hosts/${hostname}.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit username;
            homedir = "/home/${username}";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
        }
      ];
    };
}
