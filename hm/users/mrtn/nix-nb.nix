{
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    nixWallpaperFromScheme
    ;
in
rec {
  imports = [ ./secrets.nix ];

  appearance.wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    logoScale = 8;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };
  appearance.opacity = 0.95;
  appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  appearance.fontSize = 14;
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
