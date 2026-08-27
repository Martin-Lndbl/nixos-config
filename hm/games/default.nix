{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    gamescope
    steam
    prismlauncher
  ];

  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match.title = "(SevTech Ages)";
      opacity = 1;
    }
  ];

}
