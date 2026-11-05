# Home Assistant for the smart lights (Tapo bulbs) and Shelly smart plugs.
# Reachable only over the tailnet: http://box:8123
{config, ...}: let
  cfg = config.services.home-assistant;
in {
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "default_config"
      "met"
      "isal"
      # TP-Link Kasa and Tapo devices, controlled over the local network.
      "tplink"
      # Shelly smart plugs (router and servers), controlled over the local network.
      "shelly"
    ];
    config = {
      default_config = {};
      # Keep UI-made automations, scenes, and scripts.
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";
    };
  };

  # Create the files that the !include lines need.
  systemd.tmpfiles.rules = [
    "f ${cfg.configDir}/automations.yaml 0644 hass hass"
    "f ${cfg.configDir}/scenes.yaml 0644 hass hass"
    "f ${cfg.configDir}/scripts.yaml 0644 hass hass"
  ];

  # 8123 is the default web port. Open it only on the tailnet, not the LAN.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [8123];
}
