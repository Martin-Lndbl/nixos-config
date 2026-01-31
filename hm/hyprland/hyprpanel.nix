{ config, ... }:
{
  stylix.targets.hyprpanel.enable = true;
  programs.hyprpanel = {
    enable = true;
    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.bluetooth.label = false;
      bar.clock.format = "%a %b %d %H:%M:%S";
      bar.layouts."${config.monitors.center}" = {
        left = [
          "dashboard"
          "workspaces"
          "windowtitle"
        ];
        middle = [
          "media"
        ];
        right = [
          "volume"
          "network"
          "clock"
          "systray"
          (if config.appearance.hasBattery then "battery" else "")
          "notifications"
        ];
      };
      bar.layouts."${config.monitors.right}" = {
        left = [
          "dashboard"
          "workspaces"
          "windowtitle"
        ];
        middle = [
          "media"
        ];
        right = [
          "volume"
          "clock"
          (if config.appearance.hasBattery then "battery" else "")
          "notifications"
        ];
      };

      theme = {
        font.size = config.appearance.fontSize;
        bar.transparent = true;
        bar.location = "bottom";
      };
    };
  };

}
