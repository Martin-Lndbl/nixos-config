{
  pkgs,
  config,
  ...
}:
rec {
  imports = [ ./secrets.nix ];

  home.packages = with pkgs; [
    prismlauncher
    iio-sensor-proxy
    iio-hyprland
    wvkbd
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd(
      [[sh -c 'pkill -x wvkbd-mobintl || wvkbd-mobintl -L 250 &']]))
  '';

  appearance.wallpaper = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/cozy-winterscape-3840x2160-21319.jpg";
    hash = "sha256-knweYThXi1bhUBz2sjjdwhbyRE5Jni1y9A1TWIbO0do=";
  };
  appearance.opacity = 0.95;
  appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  appearance.fontSize = 12;
  appearance.hasBattery = true;
  monitors.center = "eDP-1";

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = monitors.center;
      mode = "1920x1080@60";
      position = "-1920x1080";
      scale = 1;
    }
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
      mirror = "eDP-1";
    }
  ];
  programs.caelestia.settings.bar = {
    persistent = true;
    showOnHover = false;
    workspaces = {
      shown = 9;
      showWindows = true;
      maxWindowIcons = 3;
      activeIndicator = true;
      perMonitorWorkspaces = false;
    };
    status = {
      showAudio = true;
      showMicrophone = true;
      showNetwork = true;
      showWifi = true;
      showBluetooth = true;
      showBattery = true;
      showKbLayout = false;
    };
    clock = {
      showDate = false;
      showIcon = true;
      background = true;
    };
    activeWindow = {
      compact = true;
      showOnHover = true;
    };
    tray.compact = true;
    scrollActions = {
      workspaces = true;
      volume = true;
      brightness = true;
    };
    entries = [
      {
        id = "logo";
        enabled = true;
      }
      {
        id = "workspaces";
        enabled = true;
      }
      {
        id = "spacer";
        enabled = true;
      }
      {
        id = "activeWindow";
        enabled = true;
      }
      {
        id = "spacer";
        enabled = true;
      }
      {
        id = "tray";
        enabled = true;
      }
      {
        id = "clock";
        enabled = true;
      }
      {
        id = "statusIcons";
        enabled = true;
      }
      {
        id = "power";
        enabled = true;
      }
    ];
  };
}
