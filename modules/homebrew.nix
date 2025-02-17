{...}: {
  homebrew = {
    enable = true;

    casks = [
      "raycast"
      "ghostty"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
