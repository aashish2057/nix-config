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
  }: let
    system = "aarch64-darwin";
  in
    nix-darwin.lib.darwinSystem {
      inherit system;
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
}
