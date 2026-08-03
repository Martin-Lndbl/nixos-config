{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./secrets.nix ];

  appearance.wallpaper = pkgs.fetchurl {
    url = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwallpapercave.com%2Fwp%2Fwp8017938.jpg&f=1&nofb=1&ipt=3161ddd63762459e69e12e25c7135e5754bf4fdd78c9dddd54e09528cc3b2174";
    hash = "sha256-Oaw8NURPHSpDOSjfNe2JUwiGlBXgjmqvlhkeqfpU9tA=";
  };

  appearance.opacity = 0.95;

  appearance.fontSize = 16;

  monitors.center = "DP-2";
  monitors.right = "DP-1";
  monitors.primary_id = 1;

  programs.caelestia.settings.bar = {
    persistent = true;
    showOnHover = false;
    workspaces = {
      shown = 9;
      showWindows = true;
      maxWindowIcons = 5;
      activeIndicator = true;
      perMonitorWorkspaces = true;
    };
    status = {
      showAudio = true;
      showMicrophone = true;
      showNetwork = true;
      showBluetooth = false;
      showBattery = false;
      showKbLayout = false;
    };
    clock = {
      showDate = true;
      showIcon = true;
      background = true;
    };
    scrollActions = {
      workspaces = true;
      volume = true;
      brightness = false;
    };
    entries = [
      { id = "logo"; enabled = true; }
      { id = "workspaces"; enabled = true; }
      { id = "spacer"; enabled = true; }
      { id = "clock"; enabled = true; }
      { id = "spacer"; enabled = true; }
      { id = "tray"; enabled = true; }
      { id = "statusIcons"; enabled = true; }
      { id = "power"; enabled = true; }
    ];
  };

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = config.monitors.center;
      mode = "3840x2160";
      position = "0x0";
      scale = 1;
    }
    {
      output = config.monitors.right;
      mode = "3840x2160";
      position = "3840x0";
      scale = 1;
    }
    {
      output = "HDMI-A-2";
      mode = "preferred";
      position = "auto";
      scale = 1;
    }
  ];
}
