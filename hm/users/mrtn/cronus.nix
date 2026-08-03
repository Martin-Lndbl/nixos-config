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
    };
    scrollActions = {
      workspaces = true;
      volume = true;
      brightness = false;
    };
    activeWindow.compact = false;
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
