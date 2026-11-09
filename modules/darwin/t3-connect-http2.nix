{...}: {
  # T3 Connect's cloudflared tunnel stalls over QUIC behind Zscaler's full-tunnel
  # VPN, while cloudflared still reports itself healthy, so T3 Code never falls
  # back on its own. Force HTTP/2; T3 Code honors an explicit
  # TUNNEL_TRANSPORT_PROTOCOL (https://github.com/pingdotgg/t3code/issues/16344).
  # TODO: remove once https://github.com/pingdotgg/t3code/issues/29004 is fixed.
  #
  # launchd.user.envVariables only runs during activation and does not survive a
  # reboot (https://github.com/nix-darwin/nix-darwin/issues/420), so set it from
  # a login agent instead.
  home-manager.sharedModules = [
    {
      launchd.agents.t3-connect-http2 = {
        enable = true;
        config = {
          ProgramArguments = ["/bin/launchctl" "setenv" "TUNNEL_TRANSPORT_PROTOCOL" "http2"];
          RunAtLoad = true;
        };
      };
    }
  ];
}
