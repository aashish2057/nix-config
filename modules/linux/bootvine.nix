{bootvine, ...}: {
  imports = [bootvine.nixosModules.default];

  services.bootvine.enable = true;
}
