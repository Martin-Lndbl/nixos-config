# A guest account with KDE Plasma (taskbar and start menu, the closest thing to
# Windows on offer) whose traffic can only leave through AirVPN.
#
# The tunnel lives in the "airvpn" network namespace (./airvpn.nix). A veth
# pair links the root namespace to it, and the guest's uid is policy-routed
# into that link, so every socket the guest opens - whatever the program - ends
# up NATed out of wg-air. The routing rules are permanent and fail closed:
# when the link or the tunnel is down the guest's table is empty and the next
# rule makes everything unreachable instead of falling through to the main
# table. That also keeps the guest off the LAN and the pyroeis/eos tunnels.
#
# DNS needs its own path: the system resolver is dnsmasq on loopback, which
# would ask upstream from its own uid, outside the tunnel. Guest DNS is
# redirected to a second dnsmasq running *as the guest*, whose queries to
# AirVPN's resolver are then routed like any other guest traffic.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = "guest";
  uid = 1001;

  # From ./airvpn.nix
  netns = "airvpn";
  tunnel = "wireguard-wg-air";
  wgDev = "wg-air";

  hostDev = "air-guest";
  nsDev = "air-guest-ns";
  host4 = "10.200.200.1";
  ns4 = "10.200.200.2";
  net4 = "10.200.200.0/30";
  host6 = "fd5c:a1e5:7000::1";
  ns6 = "fd5c:a1e5:7000::2";
  net6 = "fd5c:a1e5:7000::/64";
  # wg-air's MTU, so nothing has to be fragmented at the tunnel
  mtu = "1320";

  table = "200";
  # Set on everything arriving over the link. Strict reverse-path filtering
  # (rp_filter=1) would otherwise look the replies' sources up in the main
  # table, find the uplink rather than the link and drop them.
  mark = "0x4755";

  dnsPort = "5300";
  airvpnDns = "10.128.0.1";

  ip = "${pkgs.iproute2}/bin/ip";
in
{
  users.users.${user} = {
    isNormalUser = true;
    inherit uid;
    description = "Guest";
    # Locked, so no password - not even an empty one - gets the guest in
    # anywhere (login's stack has nullok). Only the rules below let it in.
    hashedPassword = "!";
    # mrtn's Firefox comes from home-manager. No need for firefox-vpn here:
    # everything the guest runs is in the tunnel already.
    packages = [ pkgs.firefox ];
  };
  # With mutableUsers, hashedPassword only applies to a newly created user.
  # The account first existed with an empty password, so lock it here.
  system.activationScripts.guest-locked = {
    deps = [ "users" ];
    text = "${pkgs.shadow}/bin/usermod -p '!' ${user}";
  };

  # The login screen (./wm/regreet.nix) lets the guest in without asking, and
  # so does Plasma's lock screen, which would otherwise never unlock again.
  # greetd's stack is just a substack of login's; these rules run before it.
  security.pam.services =
    lib.genAttrs
      [
        "greetd"
        "kde"
      ]
      (_: {
        rules.auth.guest = {
          order = 10000;
          control = "sufficient";
          modulePath = "${pkgs.pam}/lib/security/pam_succeed_if.so";
          args = [
            "user"
            "="
            user
          ];
        };
      });

  services.desktopManager.plasma6.enable = true;
  # Kontact & co. are no use to a guest and add a lot to the closure.
  programs.kde-pim.enable = false;
  # Plasma turns this on. It looks locations up as its own user, which would
  # bypass the tunnel for the guest, and nothing on this machine used it.
  services.geoclue2.enable = false;

  # The guest's session starts with Firefox and with this screen layout.
  # Hyprland's layout (hm/users/mrtn/cronus.nix) is mrtn's alone; Plasma keeps
  # its own per user. Both monitors are scaled up alike, the left one (DP-2)
  # is primary, and the TV mirrors it. Primary matters beyond looks: the TV connects first at boot,
  # so Plasma otherwise makes the TV primary and puts the only panel there.
  systemd.tmpfiles.settings."10-guest-session" =
    let
      home = config.users.users.${user}.home;
      owned = {
        inherit user;
        group = "users";
        mode = "0700";
      };
      ksd = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor";
      displays = pkgs.writeShellScript "guest-displays" ''
        # 3840 / 1.75 = 2194.3, the left monitor's logical width
        ${ksd} \
          output.DP-2.enable output.DP-2.priority.1 \
          output.DP-2.scale.1.75 output.DP-2.position.0,0 \
          output.DP-1.enable output.DP-1.priority.2 \
          output.DP-1.scale.1.75 output.DP-1.position.2194,0
        # Separately: with the TV switched off there is no HDMI-A-1, and
        # kscreen-doctor drops a whole call over one unknown output.
        ${ksd} output.HDMI-A-1.enable output.HDMI-A-1.mirror.DP-2 || true
      '';
      displaysDesktop = pkgs.writeText "guest-displays.desktop" ''
        [Desktop Entry]
        Type=Application
        Name=Guest screen layout
        Exec=${displays}
        OnlyShowIn=KDE;
        X-KDE-autostart-phase=1
      '';
    in
    {
      "${home}/.config".d = owned;
      "${home}/.config/autostart".d = owned;
      "${home}/.config/autostart/guest-displays.desktop"."L+".argument = "${displaysDesktop}";
      "${home}/.config/autostart/firefox.desktop"."L+".argument =
        "${pkgs.firefox}/share/applications/firefox.desktop";
      # A fresh default desktop every boot, panel included. Whatever a guest
      # rearranged (or a panel left stranded on the TV) does not carry over.
      "${home}/.config/plasma-org.kde.plasma.desktop-appletsrc".r = { };
    };

  # Permanent and independent of the link: the guest's traffic goes to the
  # link's table or nowhere. Priority sits above main (32766), below local (0),
  # so loopback and the machine's own addresses stay reachable.
  systemd.services.airvpn-guest-rules = {
    description = "Route the guest account into AirVPN only";
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];
    after = [ "network-pre.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for v in -4 -6; do
        ${ip} $v rule del priority 100 2>/dev/null || true
        ${ip} $v rule del priority 101 2>/dev/null || true
        ${ip} $v rule del priority 102 2>/dev/null || true
        ${ip} $v rule add priority 100 fwmark ${mark} lookup ${table}
        ${ip} $v rule add priority 101 uidrange ${toString uid}-${toString uid} lookup ${table}
        ${ip} $v rule add priority 102 uidrange ${toString uid}-${toString uid} unreachable
      done
    '';
    preStop = ''
      for v in -4 -6; do
        for p in 100 101 102; do ${ip} $v rule del priority $p || true; done
      done
    '';
  };

  # Second line of defence, should the routing ever let something through:
  # guest sockets may only use loopback and the link. Plus the DNS redirect.
  networking.nftables.tables.airvpn-guest = {
    family = "inet";
    content = ''
      chain dns {
        type nat hook output priority dstnat; policy accept;
        meta skuid ${toString uid} ip daddr 127.0.0.0/8 meta l4proto { tcp, udp } th dport 53 dnat ip to 127.0.0.1:${dnsPort}
        meta skuid ${toString uid} ip6 daddr ::1 meta l4proto { tcp, udp } th dport 53 dnat ip6 to [::1]:${dnsPort}
      }

      chain out {
        type filter hook output priority filter; policy accept;
        # Only ever match on the uid: packets the kernel sends on its own
        # (resets, ICMP) have no socket, and a negated match would reject them.
        meta skuid ${toString uid} oifname { "lo", "${hostDev}" } accept
        meta skuid ${toString uid} counter reject
      }

      chain mark-link {
        type filter hook prerouting priority mangle; policy accept;
        iifname "${hostDev}" meta mark set ${mark}
      }
    '';
  };

  # The link itself. Brought up by the guest's login and taken down after it,
  # starting the (on-demand) tunnel first. Until it is up the guest is simply
  # offline.
  systemd.services.airvpn-guest-link = {
    description = "Link the guest account to the AirVPN namespace";
    requires = [ "airvpn-guest-rules.service" ];
    after = [ "airvpn-guest-rules.service" ];
    # Gone with the tunnel: deleting the namespace takes the veth peer along.
    partOf = [ "${tunnel}.service" ];
    path = [
      pkgs.iproute2
      pkgs.nftables
      pkgs.systemd
      pkgs.coreutils
    ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 10;
    };
    script = ''
      # The tunnel resolves its endpoint when it starts, so give the network a
      # while to come up.
      for _ in $(seq 12); do
        systemctl start ${tunnel}.target && systemctl -q is-active ${tunnel}.service && break
        sleep 5
      done
      systemctl -q is-active ${tunnel}.service

      ip link del ${hostDev} 2>/dev/null || true
      ip link add ${hostDev} mtu ${mtu} type veth peer name ${nsDev} mtu ${mtu} netns ${netns}
      ip addr add ${host4}/30 dev ${hostDev}
      ip -6 addr add ${host6}/64 dev ${hostDev} nodad
      ip -n ${netns} addr add ${ns4}/30 dev ${nsDev}
      ip -n ${netns} -6 addr add ${ns6}/64 dev ${nsDev} nodad
      echo 1 > /proc/sys/net/ipv4/conf/${hostDev}/src_valid_mark
      ip link set ${hostDev} up
      ip -n ${netns} link set ${nsDev} up

      ip netns exec ${netns} ${pkgs.runtimeShell} -c '
        echo 1 > /proc/sys/net/ipv4/ip_forward
        echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
      '
      ip netns exec ${netns} nft -f - <<'EOF'
      table inet guest-nat
      delete table inet guest-nat
      table inet guest-nat {
        chain postrouting {
          type nat hook postrouting priority srcnat; policy accept;
          oifname "${wgDev}" ip saddr ${net4} masquerade
          oifname "${wgDev}" ip6 saddr ${net6} masquerade
        }
      }
      EOF

      ip route replace default via ${ns4} dev ${hostDev} table ${table}
      ip -6 route replace default via ${ns6} dev ${hostDev} table ${table}
    '';
    preStop = ''
      ip link del ${hostDev} || true
      ip route flush table ${table} || true
      ip -6 route flush table ${table} || true
      ip netns exec ${netns} nft delete table inet guest-nat 2>/dev/null || true
    '';
  };

  # The guest's resolver (see the top). Running as the guest is the point:
  # its upstream queries are guest traffic and get routed like it.
  systemd.services.airvpn-guest-dns = {
    description = "DNS for the guest account, through AirVPN";
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      User = user;
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.dnsmasq}/bin/dnsmasq"
        "--keep-in-foreground"
        "--conf-file=/dev/null"
        "--no-resolv"
        "--no-hosts"
        "--server=${airvpnDns}"
        "--listen-address=127.0.0.1"
        "--listen-address=::1"
        "--port=${dnsPort}"
        "--bind-interfaces"
        "--user="
        "--group="
        "--pid-file="
      ];
      Restart = "on-failure";
    };
  };

  # Tie both to the guest being logged in. wantedBy only adds a .wants link;
  # declaring user@1001 itself, even as a drop-in, would also hand the
  # guest's user manager NixOS's minimal service PATH.
  systemd.services.airvpn-guest-link.wantedBy = [ "user@${toString uid}.service" ];
  systemd.services.airvpn-guest-dns.wantedBy = [ "user@${toString uid}.service" ];
}
