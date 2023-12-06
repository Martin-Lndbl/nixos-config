{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ape
  ];

  xdg.desktopEntries.ape = {
    name = "ApE";
    genericName = "ApE";
    exec = "ape";
    terminal = false;
    categories = [ "Application" "Network" ];
  };
}
