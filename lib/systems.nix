{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  nix-darwin,
  self,
  mnw,
  ...
}: {
  mkDarwinSystem = {
    hostname,
    username,
    system,
    isWork ? false,
  }:
    nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit username self system isWork mnw;
        homedir = "/Users/${username}";
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
      modules = [
        ../hosts/${hostname}/${hostname}.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  mkNixosSystem = {
    hostname,
    username,
    system,
    isWork ? false,
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit username hostname system isWork mnw;
        homedir = "/home/${username}";
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
      modules = [
        ../hosts/${hostname}/${hostname}.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
