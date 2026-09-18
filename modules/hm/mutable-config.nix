{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.xdg.mutableConfigFiles;
in
{
  options.xdg.mutableConfigFiles = mkOption {
    description = ''
      Paths under XDG_CONFIG_HOME that home-manager renders but the application
      itself rewrites at runtime. Home-manager would link them read-only into
      the store; listing them here links them as usual and then swaps in a
      writable copy, so the rendered file is the starting point of every
      generation rather than a permanent one.
    '';
    type = types.listOf types.str;
    default = [ ];
    example = [ "Nextcloud/nextcloud.cfg" ];
  };

  config = lib.mkIf (cfg != [ ]) {
    # Overwrite whatever the last generation left behind.
    xdg.configFile = lib.genAttrs cfg (_: { force = true; });

    home.activation.mutableConfigFiles = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      for f in ${lib.escapeShellArgs (map (p: "${config.xdg.configHome}/${p}") cfg)}; do
        if [ -L "$f" ]; then
          target=$(readlink -f "$f")
          run rm "$f"
          run cp "$target" "$f"
          run chmod u+w "$f"
        fi
      done
    '';
  };
}
