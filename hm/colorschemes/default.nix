{ pkgs, ... }:
{
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.image = pkgs.fetchurl {
    url = "https://getwallpapers.com/wallpaper/download/168517";
    hash = "sha256-EUxtQ2y5c92BzTR605re7rJTIyEx+Hy+5O3q3Y2PprM=";
  };
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";

  stylix.targets.firefox.profileNames = [ "default" ];
}
