{...}: {
  home-manager.sharedModules = [
    ({config, ...}: {
      xdg.configFile."rift/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Dev/nix-config/modules/darwin/rift/config.toml";
    })
  ];
}
