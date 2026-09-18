{ pkgs, ... }:
{
  # steam itself comes from programs.steam on the host, see ../../nixos/machines.
  home.packages = with pkgs; [
    vitetris
    gamescope
    prismlauncher
  ];

  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match.title = "(SevTech Ages)";
      opacity = 1;
    }
  ];
}
