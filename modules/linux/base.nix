{
  username,
  hostname,
  ...
}: {
  imports = [
    ./i18n.nix
    ./desktop.nix
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
  };

  services.tailscale = {
    enable = true;
    # Tailscale SSH: tailscaled serves SSH on the tailnet, authorized by the
    # tailnet policy's `ssh` rules.
    extraSetFlags = ["--ssh"];
  };
}
