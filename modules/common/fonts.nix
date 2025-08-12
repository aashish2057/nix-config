{pkgs}: {
  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
  ];

  fonts.fontconfig = {
    enable = true;
    hinting.enable = true;
    defaultFonts = {
      monospace = ["Geist Mono"];
    };
  };
}
