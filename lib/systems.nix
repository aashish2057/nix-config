{
  nixpkgs,
  home-manager,
  nix-darwin,
  self,
  mnw,
  nvim-nightly,
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
        inherit username self system isWork mnw nvim-nightly;
        homedir = "/Users/${username}";
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
        inherit username hostname system isWork mnw nvim-nightly;
        homedir = "/home/${username}";
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
