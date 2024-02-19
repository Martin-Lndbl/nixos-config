{ pkgs, config, ... }:

{
  home.packages = [ pkgs.grim ];

  home.sessionVariables.GRIM_DEFAULT_DIR =
    config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR;
}
