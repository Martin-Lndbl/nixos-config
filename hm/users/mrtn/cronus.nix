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
    width = 3840;
    height = 2160;
    logoScale = 16;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };

  appearance.opacity = 0.96;

  appearance.fontSize = 18;
  monitors.center = "DP-3";
  monitors.right = "DP-4";
  monitors.primary_id = 0;

wayland.windowManager.hyprland.settings.monitor = [
    "${config.monitors.center}, 3840x2160, 0x0, 1"
    "${config.monitors.right}, 3840x2160, 3840x0, 1"
  ];
}
