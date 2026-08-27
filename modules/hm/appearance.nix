{ lib, ... }:

let
  inherit (lib) mkOption types;
  pathOrStr = types.oneOf [
    types.path
    types.str
  ];
in
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
      default = 0.95;
    };
    wallpaper = mkOption {
      description = "Wallpaper";
      type = pathOrStr;
    };
    profile.picture = mkOption {
      description = "Profile picture";
      type = pathOrStr;
    };
  };
}
