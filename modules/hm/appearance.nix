{ config, lib, ... }:

let
  cfg = config.appearance;

  opacity = if builtins.match "[0/1].*" config.colorscheme.palette.base00 == null then 0.85 else 0.95;

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
      default = opacity;
    };
    wallpaper = mkOption {
      description = "Wallpaper";
      type = types.oneOf [
        types.path
        types.str
      ];
    };
    lockScreen = mkOption {
      description = "Lockscreen wallpaper";
      type = types.oneOf [
        types.path
        types.str
      ];
      default = cfg.wallpaper;
    };
    profile.picture = mkOption {
      description = "Profile picture";
      type = types.oneOf [
        types.path
        types.str
      ];
    };
  };
}
