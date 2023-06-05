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
    wallpaper = mkOption {
      description = "Wallpaper";
      type = types.path;
      default = builtins.fetchurl {
        url = "https://wallha.com/download/ws/14/4wfKF3NT-wallha.com.png";
        sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
      };
    };
    lockScreen = mkOption {
      description = "Lockscreen";
      type = types.path;
      default = cfg.wallpaper;
    };
  };
}
