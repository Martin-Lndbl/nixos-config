{ config, pkgs, ... }:

let
  wallpaperPath = "${config.xdg.stateHome}/caelestia/wallpaper/path.txt";
  borderColour = "${config.xdg.stateHome}/hypr/border-colour.lua";

  accent = pkgs.writers.writePython3Bin "hypr-border-accent" {
    libraries = [ pkgs.python3Packages.pillow ];
  } (builtins.readFile ./border-accent.py);

  update = pkgs.writeShellApplication {
    name = "hypr-border-colour";
    runtimeInputs = [ accent ];
    text = ''
      wallpaper=$(cat ${wallpaperPath} 2>/dev/null || true)
      if [ -z "$wallpaper" ] || [ ! -e "$wallpaper" ]; then
        exit 0
      fi

      mkdir -p "$(dirname ${borderColour})"
      # Written via a temporary file because hyprland.nix dofile()s this on
      # every reload, and a reload can land while it is being rewritten.
      printf 'return {\n  active = "rgba(%sff)"\n}\n' \
        "$(hypr-border-accent "$wallpaper")" > ${borderColour}.tmp
      mv ${borderColour}.tmp ${borderColour}

      # hyprctl comes from the system hyprland: wayland.windowManager.hyprland
      # sets package = null, so home-manager builds none of its own.
      /run/current-system/sw/bin/hyprctl reload >/dev/null 2>&1 || true
    '';
  };
in
{
  # Caelestia only re-derives colours from the wallpaper under its "dynamic"
  # scheme, which would drag the terminal and nvim palettes along with it. Its
  # named schemes, including our "classic", are fixed, so nothing caelestia
  # renders can track the wallpaper on its own. Extract a colour for the
  # border alone instead: it is the one surface where the colour is purely
  # decorative and cannot cost legibility the way ANSI or syntax colours do.
  systemd.user.services.hypr-border-colour = {
    Unit = {
      Description = "Derive the Hyprland border colour from the wallpaper";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${update}/bin/hypr-border-colour";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # caelestia writes path.txt in place on every wallpaper change, so
  # PathChanged fires on its close.
  systemd.user.paths.hypr-border-colour = {
    Unit.Description = "Watch for wallpaper changes";
    Path.PathChanged = wallpaperPath;
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
