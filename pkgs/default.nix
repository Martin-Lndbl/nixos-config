{
  pkgs ? (import ../nixpkgs.nix) { },
}:
rec {
  # Blocks until a host behind the pyroeis WireGuard tunnel is actually
  # reachable (or 60s pass), then runs its arguments if any were given.
  wait-for-pyroeis = pkgs.writeShellApplication {
    name = "wait-for-pyroeis";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
    ];
    text = ''
      probe_url="https://nextcloud.lndbl.de/status.php"

      deadline=$(($(date +%s) + 60))
      until curl -fs -o /dev/null --max-time 5 "$probe_url"; do
        if [ "$(date +%s)" -ge "$deadline" ]; then
          echo "pyroeis still unreachable after 60s, continuing anyway" >&2
          break
        fi
        sleep 1
      done

      if [ "$#" -gt 0 ]; then
        exec "$@"
      fi
    '';
  };

  # Runs a command as the calling user inside the "airvpn" network namespace
  # (see nixos/airvpn.nix), starting the tunnel first if it is down. Re-execs
  # itself through sudo for the privileged part, then drops back to the
  # invoking user with the environment intact.
  airvpn-run = pkgs.writeShellApplication {
    name = "airvpn-run";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.getent
      pkgs.iproute2
      pkgs.systemd
      pkgs.util-linux
    ];
    text = ''
      netns=airvpn
      unit=wireguard-wg-air.target
      key=/var/lib/wireguard/wg-air.key
      psk=/var/lib/wireguard/wg-air.psk

      if [ "$#" -eq 0 ]; then
        echo "usage: airvpn-run <command> [args...]" >&2
        exit 64
      fi

      if [ "$(id -u)" -ne 0 ]; then
        exec sudo -E "${placeholder "out"}/bin/airvpn-run" "$@"
      fi

      if [ -z "''${SUDO_USER:-}" ] || [ "$SUDO_USER" = root ]; then
        echo "airvpn-run: must be started by a regular user via sudo" >&2
        exit 1
      fi

      if [ ! -r "$key" ] || [ ! -r "$psk" ]; then
        echo "airvpn-run: $key or $psk is missing; export them from the NetworkManager profile first" >&2
        exit 1
      fi

      if ! systemctl -q is-active "$unit"; then
        systemctl start "$unit"
      fi

      home=$(getent passwd "$SUDO_USER" | cut -d: -f6)
      exec ip netns exec "$netns" \
        runuser -p -u "$SUDO_USER" -- \
        env HOME="$home" USER="$SUDO_USER" LOGNAME="$SUDO_USER" "$@"
    '';
  };

  # A second Firefox, with its own profile, living behind AirVPN. The explicit
  # profile path plus --no-remote keeps it from handing the URL to the normal
  # instance, which would open it outside the tunnel.
  firefox-vpn = pkgs.writeShellApplication {
    name = "firefox-vpn";
    runtimeInputs = [ airvpn-run ];
    text = ''
      firefox=$(command -v firefox) || {
        echo "firefox-vpn: firefox not on PATH" >&2
        exit 1
      }
      profile="$HOME/.config/mozilla/firefox/vpn"
      mkdir -p "$profile"
      exec airvpn-run "$firefox" --no-remote --profile "$profile" "$@"
    '';
  };
}
