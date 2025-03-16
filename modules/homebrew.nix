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
      "cold-turkey-blocker"
      "legcord"
    ];

    taps = [
      "nikitabobko/tap"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
