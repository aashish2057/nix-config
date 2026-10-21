{...}: {
  home-manager.sharedModules = [
    ({config, ...}: {
      xdg.configFile."rex".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Dev/nix-config/modules/darwin/rex";
    })
  ];
}
