{...}: {
  homebrew = {
    enable = true;

    casks = [
      "raycast"
      "ghostty"
      "obsidian"
      "font-geist-mono-nerd-font"
      "aerospace"
      "flux-app"
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
