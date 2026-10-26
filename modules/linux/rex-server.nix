# Rex login server on every Linux host, reachable from Rex for Mac over Tailscale Serve.
# https://www.superlogical.com/rex/docs/linux/installation
#
# Until Rex's first release, fetching the flake needs a package token in
# /etc/nix/netrc:
#   machine pkgs.superlogical.com login rex password <REX_PACKAGE_TOKEN>
{
  rex,
  username,
  ...
}: {
  imports = [rex.nixosModules.default];

  services.rex.loginServer = {
    enable = true;
    accounts.${username}.principals = ["tailscale:aashish2057@github"];
    tailscaleServe.enable = true;
  };
}
