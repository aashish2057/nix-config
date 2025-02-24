{...}: {
  homebrew = {
    enable = true;

    casks = [
      "raycast"
      "ghostty"
      "arc"
      "obsidian"
      "font-geist-mono-nerd-font"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
