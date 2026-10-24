{...}: {
  imports = [
    ../../modules/common/zsh.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/mise.nix
  ];

  profiles.desktop.enable = true;

  # TODO: remove once nixpkgs-unstable includes https://github.com/NixOS/nixpkgs/pull/576874.
  # fabric 3.2.3 is marked broken with invoke 3, which breaks azure-cli.
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions =
        prev.pythonPackagesExtensions
        ++ [
          (pyfinal: pyprev: {
            fabric = pyprev.fabric.overridePythonAttrs (old: {
              version = "3.2.3-unstable-2026-04-07";
              src = final.fetchFromGitHub {
                owner = "fabric";
                repo = "fabric";
                rev = "cc098ad475dbbe2e10aba72692d83aee58919570";
                hash = "sha256-Z1tGcjdLrzbqcbS6XwapSgDNpyLbBiO21yeqi7XhbpQ=";
              };
              meta = old.meta // {broken = false;};
            });
          })
        ];
    })
  ];
}
