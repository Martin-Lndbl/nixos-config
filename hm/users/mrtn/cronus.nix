{
  config,
  ...
}:
{
  imports = [ ./secrets.nix ];

  appearance.wallpaper = "${config.xdg.userDirs.pictures}/wallpaper.jpg";

  appearance.opacity = 0.95;

  stylix.fonts.sizes.terminal = 16;

  monitors.center = "DP-3";
  monitors.right = "DP-4";
  monitors.primary_id = 0;

  wayland.windowManager.hyprland.settings.monitor = [
    "${config.monitors.center}, 3840x2160, 0x0, 1"
    "${config.monitors.right}, 3840x2160, 3840x0, 1"
  ];
}
