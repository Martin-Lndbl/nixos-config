{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    calc
  ];

  xdg.desktopEntries.calc = {
    name = "Calc";
    genericName = "Calculator";
    exec = "alacritty -e calc";
    terminal = false;
    type = "Application";
    categories = [ "Application" ];
  };
}
