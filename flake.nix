{
  description = "Basic nix conf";
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
  }: {
    darwinConfigurations = {
      Aashishs-MacBook-Pro = let
        username = "aashishsharma";
        system = "aarch64-darwin";
        homedir = "/Users/${username}";
        specialArgs = {inherit username system homedir self;};
      in
        nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          modules = [
            ./hosts/aashishs-macbook-pro.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username homedir;
              };
              home-manager.users.${username} = import ./users/${username}.nix;
            }
          ];
        };

      Aashishs-Work-MacBook-Pro = let
        username = "aashishsharmawork";
        system = "aarch64-darwin";
        homedir = "/Users/${username}";
        specialArgs = {inherit username system homedir self;};
      in
        nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          modules = [
            ./hosts/aashishs-work-macbook-pro.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username homedir;
              };
              home-manager.users.${username} = import ./users/${username}.nix;
            }
          ];
        };
    };
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
  };
}
