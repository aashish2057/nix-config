{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  ...
}: {
  mkNixosSystem = {
    hostname,
    username,
    system,
    isWork ? false,
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit username hostname system isWork;
        homedir = "/home/${username}";
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
      modules = [
        ../modules/core.nix
        ../modules/nixos.nix
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
