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
}
