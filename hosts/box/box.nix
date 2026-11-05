{...}: {
  imports = [
    ./hardware.nix
    ../../modules/linux/boot.nix
    ../../modules/linux/obsidian-headless.nix
    ../../modules/linux/t3code-server.nix
    ../../modules/linux/home-assistant.nix
  ];

  system.stateVersion = "25.11";

  # Let box act as a Tailscale subnet router (turns on IP forwarding).
  # The advertised route is set by hand with `tailscale set`.
  services.tailscale.useRoutingFeatures = "server";

  agents = {
    claude = true;
    codex = true;
  };
}
