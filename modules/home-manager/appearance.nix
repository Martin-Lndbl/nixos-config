{ config, lib, ... }:

let
  cfg = config.appearance;

in
with lib;
{
  options.appearance = {
    fontSize = mkOption {
      description = "Font Size of default terminal";
      type = types.int;
      default = 14;
    };
    opacity = mkOption {
      description = "Set the opacity for inactive hyprland clients";
      type = types.float;
      default = 0.8;
    };
    wallpaper = mkOption {
      description = "Wallpaper";
      type = types.str;
    };
    lockScreen = mkOption {
      description = "Lockscreen";
      type = types.str;
      default = cfg.wallpaper;
    };
  };
}
