{ inputs, pkgs, lib, config, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    nixWallpaperFromScheme;
in
{
  config.appearance.wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    logoScale = 8;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };
  config.appearance.lockScreen = "~/downloads/wallpaper/nix.png";
  config.appearance.fontSize = 14;
  config.monitors.center = "eDP-1";
  config.monitors.right = "DP-1";
}
