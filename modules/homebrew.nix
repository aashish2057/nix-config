{...}: {
  homebrew = {
    enable = true;

    casks = [
      "raycast"
      "ghostty"
      "arc"
      "obsidian"
      "font-geist-mono-nerd-font"
      "aerospace"
      "flux"
      "jordanbaird-ice"
    ];

    taps = [
      "nikitabobko/tap"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
