{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
  ];

  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match.class = "anki";
      tile = true;
    }
  ];
}
