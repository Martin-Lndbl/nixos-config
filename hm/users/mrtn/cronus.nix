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
{
  imports = [ ./secrets.nix ];

  appearance.wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    logoScale = 8;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };

  appearance.opacity = 0.96;

  appearance.fontSize = 18;
  monitors.center = "DP-1";
  monitors.right = "HDMI-A-1";
  monitors.primary_id = 1;

  programs.git = {
    userName = "Martin-Lindbuechl@cronus";
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "${config.monitors.center}, 3840x2160, 0x0, 1"
    "${config.monitors.right}, 3840x2160, 3840x0, 1"
  ];
}
