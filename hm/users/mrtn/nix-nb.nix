{
  pkgs,
  config,
  ...
}:
rec {
  imports = [ ./secrets.nix ];

  appearance.wallpaper = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/cozy-winterscape-3840x2160-21319.jpg";
    hash = "sha256-knweYThXi1bhUBz2sjjdwhbyRE5Jni1y9A1TWIbO0do=";
  };
  appearance.opacity = 0.95;
  appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  appearance.fontSize = 14;
  appearance.hasBattery = true;
  monitors.center = "DP-6";
  monitors.left = "eDP-1";
  monitors.right = "DP-7";

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "${monitors.left}, 1920x1080@60, -1920x1080, 1"
      "${monitors.center}, 3840x2160@60, 0x0, 1"
      "${monitors.right}, 1920x1080@60, 3840x540, 1"
      " , preferred, auto, 1, mirror, eDP-1"
    ];
  };

  programs.bash.shellAliases = {
    cdsem = "cd ~/documents/bsc_info/07_sem/";
  };
}
