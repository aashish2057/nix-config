{...}: {
  home-manager.sharedModules = [
    ({config, ...}: {
      programs.quickshell = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."quickshell".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/Dev/nix-config/modules/linux/quickshell";
    })
  ];
}
