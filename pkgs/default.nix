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
}
