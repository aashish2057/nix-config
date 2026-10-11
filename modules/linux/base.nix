{
  username,
  hostname,
  ...
}: {
  imports = [
    ./i18n.nix
  ];

  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    description = "Aashish Sharma";
    extraGroups = ["networkmanager" "wheel"];
  };
}
