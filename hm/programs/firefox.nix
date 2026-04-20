{ ... }:

{
  programs.firefox.enable = true;

  stylix.targets.firefox.enable = false;
  stylix.targets.firefox.profileNames = [ ];

  wayland.windowManager.hyprland.settings.windowrule = [
    #	Downloads
    "size 800 400, match:title ^(Save)(.*)$"
    "float yes, match:title ^(Save)(.*)$"

    "size 488 316, match:title ^(Choose a color)$, match:class ^(firefox)$"

    #	Popups
    "size 50% 50%, match:title ^((?!Save)(?!Mozilla firefox).)*$, match:class ^(firefox)$"

    # Streaming
    "opacity 1, match:title ^(Netflix — Mozilla Firefox)"
    "opacity 1, match:title ^(Netflix — Mozilla Firefox)"
    "opacity 1, match:title ^(Netflix — Mozilla Firefox)"
  ]; 

}
