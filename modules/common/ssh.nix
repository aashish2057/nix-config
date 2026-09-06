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

          omnios = {
            hostname = "162.35.189.179";
            user = "dev";
            proxyJump = "pve01";
          };
        };
      };
    }
  ];
}
