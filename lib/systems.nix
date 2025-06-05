{
  nixpkgs,
  nix-darwin,
  home-manager,
  self,
}: {
  mkDarwinSystem = {
    hostname,
    username,
  }:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit username self;
        system = "aarch64-darwin";
        homedir = "/Users/${username}";
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
          };
        }
      ];
    };
}
