{
  config,
  ...
}:
{
  imports = [ ./secrets.nix ];

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

  wayland.windowManager.hyprland.settings.workspace_rule = [
    { workspace = "1"; monitor = config.monitors.center; default = true; }
    { workspace = "9"; monitor = config.monitors.right; default = true; }
  ];

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
