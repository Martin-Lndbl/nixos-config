{ inputs, pkgs, lib, config, ... }:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    nixWallpaperFromScheme;
in
{
  imports = [ ./secrets.nix ];

  config.appearance.wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    logoScale = 8;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };

  config.appearance.fontSize = 18;
  config.monitors.center = "DP-2";
  config.monitors.right = "DP-3";
}
