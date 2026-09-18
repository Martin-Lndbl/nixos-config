{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calc
  ];

  xdg.desktopEntries.calc = {
    name = "Calc";
    genericName = "Calculator";
    exec = "ghostty -e calc";
    terminal = false;
    type = "Application";
    categories = [ "Application" ];
  };
}
