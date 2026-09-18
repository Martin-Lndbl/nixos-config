{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
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

  element-sink-mute = pkgs.writeShellApplication {
    name = "element-sink-mute";
    runtimeInputs = [
      pkgs.jq
      pkgs.pipewire
      pkgs.wireplumber
    ];
    text = ''
      if [ "$#" -ne 1 ]; then
        echo "usage: element-sink-mute 1|0|toggle" >&2
        exit 2
      fi

      id=$(pw-dump | jq -r 'first(.[] | select(.info.props."node.name" == "element") | .id) // empty')

      if [ -z "$id" ]; then
        echo "no element sink in the graph" >&2
        exit 0
      fi

      wpctl set-mute "$id" "$1"
    '';
  };
}
