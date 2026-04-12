{ pkgs, config, ... }:
{
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.image = config.appearance.wallpaper;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";

  stylix.targets.neovim.transparentBackground.main = true;
  stylix.targets.neovim.transparentBackground.signColumn = true;
  stylix.targets.neovim.transparentBackground.numberLine = true;

  stylix.opacity.terminal = 0.97;
}
