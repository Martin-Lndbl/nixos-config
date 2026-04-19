{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    gamescope
    steam
    prismlauncher
  ];

  wayland.windowManager.hyprland.settings.windowrule = [ "opacity 1, match:title (SevTech Ages)" ];

}
