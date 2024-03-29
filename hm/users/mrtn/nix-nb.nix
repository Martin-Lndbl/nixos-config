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
  config.appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  config.appearance.fontSize = 14;
  config.monitors.center = "eDP-1";
  config.monitors.right = "DP-1";
}
