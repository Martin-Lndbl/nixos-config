{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./secrets.nix ];

  appearance.wallpaper = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/cozy-winterscape-3840x2160-21319.jpg";
    hash = "sha256-knweYThXi1bhUBz2sjjdwhbyRE5Jni1y9A1TWIbO0do=";
  };

  appearance.opacity = 0.95;

  appearance.fontSize = 16;
  stylix.fonts.sizes.terminal = 16;

  monitors.center = "DP-3";
  monitors.right = "DP-4";
  monitors.primary_id = 1;

  services.wayle.settings.bar.layout = [
    {
      monitor = config.monitors.center;
      show = true;
      left = [
        "dashboard"
        "hyprland-workspaces"
      ];
      center = [
        "clock"
      ];
      right = [
        "cpu"
        "ram"
        "storage"
        "custom-cpu-temp"
        "notifications"
      ];
    }
    {
      monitor = config.monitors.right;
      show = true;
      left = [
        "dashboard"
        "hyprland-workspaces"
      ];
      center = [
        "media"
      ];
      right = [
        "network"
        "volume"
        "microphone"
        "notifications"
      ];
    }
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "${config.monitors.center}, 3840x2160, 0x0, 1"
    "${config.monitors.right}, 3840x2160, 3840x0, 1"
    "HDMI-A-2, preferred, auto, 1"
  ];
}
