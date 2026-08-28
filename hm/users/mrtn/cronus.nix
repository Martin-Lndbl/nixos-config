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

  # Only this host has more than one monitor.
  programs.caelestia.settings.bar.workspaces.perMonitorWorkspaces = true;

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
