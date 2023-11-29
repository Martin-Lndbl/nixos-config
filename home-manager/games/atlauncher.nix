{ pkgs, ... }:
{
  home.packages = with pkgs; [
    atlauncher
  ];

  xdg.desktopEntries.atlauncher = {
    name = "AT Launcher";
    genericName = "AT Launcher";
    exec = "atlauncher";
    terminal = false;
    categories = [ "Application" "Network" "Audio" ];
  };
}
