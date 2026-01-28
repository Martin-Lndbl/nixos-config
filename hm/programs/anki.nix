{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    "float no, match:class anki"
  ];

}
