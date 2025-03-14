{...}: {
  homebrew = {
    enable = true;

    casks = [
      "raycast"
      "ghostty"
      "arc"
      "obsidian"
      "font-geist-mono-nerd-font"
      "nikitabobko/tap/aerospace"
      "cold-turkey-blocker"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
