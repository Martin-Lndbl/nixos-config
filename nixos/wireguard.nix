{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    eduvpn-client
  ];

  networking.nftables.enable = true;
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
  networking.firewall.logReversePathDrops = true;
}
