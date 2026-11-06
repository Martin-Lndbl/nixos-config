# AirVPN as a per-application tunnel: the interface is configured in the root
# namespace, then moved into the "airvpn" namespace as its only route out.
# airvpn-run starts it on demand. The full wg-quick config is in sops.
{
  config,
  pkgs,
  ...
}:
let
  netns = "airvpn";
  dev = "wg-air";
in
{
  imports = [ ./sops.nix ];

  # wg-quick strip insists the file name is "<interface>.conf".
  sops.secrets."${dev}.conf" = {
    format = "binary";
    sopsFile = ./secrets/airvpn.conf;
  };

  systemd.services.airvpn = {
    description = "AirVPN tunnel in the ${netns} network namespace";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [
      pkgs.gawk
      pkgs.iproute2
      pkgs.wireguard-tools
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      conf=${config.sops.secrets."${dev}.conf".path}
      field() {
        awk -F '=' -v k="$1" '
          /^\[/ { sect = $0 }
          sect == "[Interface]" {
            key = $1; gsub(/[ \t]/, "", key)
            if (key == k) { sub(/^[^=]*=/, ""); gsub(/[ \t]/, ""); gsub(/,/, "\n"); print }
          }' "$conf"
      }

      ip netns del ${netns} 2>/dev/null || true
      ip link del ${dev} 2>/dev/null || true
      ip netns add ${netns}

      ip link add ${dev} type wireguard
      wg setconf ${dev} <(wg-quick strip "$conf")
      ip link set ${dev} netns ${netns}

      for addr in $(field Address); do
        ip -n ${netns} addr add "$addr" dev ${dev}
      done
      mtu=$(field MTU)
      ip -n ${netns} link set ${dev} ''${mtu:+mtu "$mtu"} up
      ip -n ${netns} link set lo up
      ip -n ${netns} route add default dev ${dev}
      ip -n ${netns} -6 route add default dev ${dev}

      mkdir -p /etc/netns/${netns}
      field DNS | awk '{ print "nameserver " $0 }' > /etc/netns/${netns}/resolv.conf
    '';

    preStop = ''
      ip netns del ${netns} || true
      rm -rf /etc/netns/${netns}
    '';
  };

  environment.systemPackages = [
    pkgs.airvpn-run
    pkgs.firefox-vpn
  ];

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
