{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
  # Blocks until the pyroeis WireGuard tunnel is up (or 60s pass), then runs
  # its arguments if any were given.
  wait-for-pyroeis = pkgs.writeShellApplication {
    name = "wait-for-pyroeis";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.networkmanager
    ];
    text = ''
      vpn_up() {
        [ "$(nmcli -g GENERAL.STATE connection show --active pyroeis 2>/dev/null)" = "activated" ]
      }

      waited=0
      while ! vpn_up && [ "$waited" -lt 60 ]; do
        sleep 1
        waited=$((waited + 1))
      done

      if ! vpn_up; then
        echo "pyroeis still down after 60s, continuing anyway" >&2
      fi

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
