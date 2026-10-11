# AirVPN as a per-application tunnel. The WireGuard interface is created in
# the root namespace (so its encrypted UDP leaves via the normal uplink) and
# then moved into the "airvpn" network namespace, where it is the only route
# out. Anything started inside that namespace can only talk through the
# tunnel; nothing else on the machine notices it exists. airvpn-run starts the
# tunnel on demand and drops a command into the namespace, so nothing here is
# brought up at boot.
{
  lib,
  pkgs,
  ...
}:
let
  netns = "airvpn";
  dev = "wg-air";
  endpointHost = "europe3.vpn.airdns.org";
  endpointPort = 1637;
  peerKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
in
{
  networking.wireguard.interfaces.${dev} = {
    # Root-only, outside the repo. Not managed by sops because nothing on the
    # NixOS side decrypts secrets yet.
    privateKeyFile = "/var/lib/wireguard/${dev}.key";
    ips = [
      "10.189.165.186/32"
      "fd7d:76ee:e68f:a993:13eb:20ce:c5f2:3e91/128"
    ];
    mtu = 1320;
    interfaceNamespace = netns;

    preSetup = ''
      ip netns list | grep -qx "${netns}" || ip netns add "${netns}"
    '';

    # The peer is configured here rather than via `peers` because the module
    # would run `wg set ... endpoint host:port` inside the namespace, where the
    # hostname cannot resolve before the tunnel is up. Resolve it out here and
    # hand wg the address.
    postSetup = ''
      endpoint=$(${pkgs.getent}/bin/getent ahostsv4 "${endpointHost}" | ${pkgs.gawk}/bin/awk 'NR == 1 { print $1 }')
      if [ -z "$endpoint" ]; then
        echo "cannot resolve ${endpointHost}" >&2
        exit 1
      fi
      # AirVPN also requires the preshared key; without it the server silently
      # ignores the handshake.
      ip netns exec "${netns}" wg set "${dev}" \
        peer "${peerKey}" \
        preshared-key /var/lib/wireguard/${dev}.psk \
        endpoint "$endpoint:${toString endpointPort}" \
        allowed-ips 0.0.0.0/0,::/0 \
        persistent-keepalive 15
      ip -n "${netns}" link set lo up
      ip -n "${netns}" route add default dev "${dev}"
      ip -n "${netns}" -6 route add default dev "${dev}"
    '';

    postShutdown = ''
      ip netns del "${netns}" || true
    '';
  };

  # On demand only: airvpn-run starts the target.
  systemd.targets."wireguard-${dev}".wantedBy = lib.mkForce [ ];

  # ip netns exec bind-mounts this over /etc/resolv.conf. The namespace has
  # its own loopback, so the root namespace's dnsmasq is unreachable from
  # inside; use AirVPN's resolver through the tunnel instead.
  environment.etc."netns/${netns}/resolv.conf".text = "nameserver 10.128.0.1\n";

  environment.systemPackages = [
    pkgs.airvpn-run
    pkgs.firefox-vpn
  ];

  # Starting the tunnel and entering the namespace both need root. The script
  # drops back to the calling user before running anything. SETENV lets
  # `sudo -E` carry the Wayland and DBus variables across.
  security.sudo.extraRules = [
    {
      users = [ "mrtn" ];
      commands = [
        {
          command = "${pkgs.airvpn-run}/bin/airvpn-run";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
  ];
}
