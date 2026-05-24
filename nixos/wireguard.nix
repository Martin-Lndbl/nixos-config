{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    eduvpn-client
  ];

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = [
        # Public Endpoints
        "/gateway.lndbl.de/8.8.8.8"
        "/matrix.lndbl.de/8.8.8.8"
        "/mail.lndbl.de/8.8.8.8"
        "/push.lndbl.de/8.8.8.8"
        "/www.lndbl.de/8.8.8.8"

        # --- Pyroeis VPN ---
        "/lndbl.de/172.16.0.1"
        "/16.172.in-addr.arpa/172.16.0.1"

        # --- Eos VPN ---
        "/home/10.10.0.1"
        "/10.10.in-addr.arpa/10.10.0.1"

        "8.8.8.8"
        "8.8.4.4"
      ];
      domain-needed = true;
      bogus-priv = true;
    };
  };

  networking.firewall.checkReversePath = false;
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 52193 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 52193 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 35923 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 35923 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 52193 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 52193 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 35923 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 35923 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };
}
