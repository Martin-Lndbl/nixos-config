{ writeShellScriptBin }:

writeShellScriptBin "rotate" ''
  # Remove 2nd line after github.com/hyprwm/Hyprland/pull/3544 is in nixpkgs
  hyprctl keyword monitor eDP-1, transform, $1 && \
    hyprctl keyword input:touchdevice:transform $1 
''
