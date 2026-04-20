{ pkgs, config, ... }:

{
  home.packages = [ pkgs.grimblast ];
  home.sessionVariables.GRIM_DEFAULT_DIR = config.xdg.userDirs.extraConfig.SCREENSHOTS;
}
