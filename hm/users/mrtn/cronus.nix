{
  config,
  ...
}:
{
  imports = [ ./secrets.nix ];

  # commits from this box are tagged with it, as on the other machines
  programs.git.settings.user.name = "Martin-Lindbuechl@cronus";

  appearance.fontSize = 16;

  monitors.center = "DP-2";
  monitors.right = "DP-1";
  # the TV in the other room, connected through the Denon AVR
  monitors.tv = "HDMI-A-1";

  # Only this host has more than one monitor.
  programs.caelestia.settings.bar.workspaces.perMonitor = true;

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
      output = config.monitors.tv;
      mode = "3840x2160@60";
      # Right of the right monitor, touching it so the cursor can get over.
      position = "7680x0";
      scale = 1;
      # Not a mirror. The TV comes up before the desk monitors at boot, so a
      # mirror rule turns it from a normal output into a mirror while the
      # autostart apps are starting; ever since that rule went in, Element
      # quit and thunderbird/feishin never mapped a window at login, and the
      # AVR showed no picture.
    }
    {
      output = "HDMI-A-2";
      mode = "preferred";
      position = "auto";
      scale = 1;
    }
  ];
}
