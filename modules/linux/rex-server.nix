# Until Rex's first release, fetching the flake needs a package token in
# /etc/nix/netrc:
#   machine pkgs.superlogical.com login rex password <REX_PACKAGE_TOKEN>
{
  config,
  lib,
  rex,
  username,
  ...
}: {
  users.users.${username}.linger = true;

  # programs.rex.sshGuard needs home-manager's programs.ssh, which only some
  # hosts enable.
  programs.ssh.extraConfig = lib.mkAfter ''
    Include ${config.home-manager.users.${username}.services.rex.package}/share/rex/ssh_config.d/50-rex.conf
  '';

  home-manager.sharedModules = [
    rex.homeManagerModules.default
    {
      programs.rex.sshGuard = false;
      services.rex = {
        enable = true;
        # Changing tailscale.hostname enrolls a new node.
        tailscale.enable = true;
      };
    }
  ];
}
