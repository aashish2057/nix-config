{...}: {
  home-manager.sharedModules = [
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          pve01 = {
            hostname = "pve01";
            user = "root";
          };
        };
      };
    }
  ];
}
