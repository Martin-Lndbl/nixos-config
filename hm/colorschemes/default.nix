{ pkgs, config, ... }:
{
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.image = config.appearance.wallpaper;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";

  stylix.opacity.terminal = 0.97;
}
