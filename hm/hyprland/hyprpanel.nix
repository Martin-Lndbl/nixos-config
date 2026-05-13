{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    btop
    power-profiles-daemon
    wf-recorder
  ];

  stylix.targets.hyprpanel.enable = true;
  programs.hyprpanel = {
    enable = true;
    settings = {
      menus = {
        dashboard = {
          powermenu.avatar.image = config.appearance.profile.picture;
          recording.path = "${config.xdg.userDirs.videos}/screenrecording";
          directories.enabled = false;
        };
        clock = {
          time = {
            military = "%H:%M:%S";
            hideSeconds = false;
          };
          weather = {
            enabled = true;
            unit = "metric";
            location = "Munich";
          };
        };
      };
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
