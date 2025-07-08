{...}: {
  homebrew = {
    enable = true;

    casks = [
      "raycast"
      "ghostty"
      "obsidian"
      "font-geist-mono-nerd-font"
      "aerospace"
      "flux"
      "jordanbaird-ice"
    ];

    brews = [
      "opencode"
    ];

    taps = [
      "nikitabobko/tap"
      "sst/tap"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
