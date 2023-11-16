{ pkgs, ... }:
{
  home.packages = with pkgs; [
   # gamemode
    vitetris
    atlauncher
  ];

  # programs.atlauncher = {
  #   enable = false;
  #   package = pkgs.unstable.atlauncher;

  #   settings = {
  #     enableAnalytics = true;
  #     enableConsole = false;
  #     enableTrayMenu = false;
  #     firstTimeRun = false;
  #     keepLauncherOpen = false;
  #     usingCustimJavaPath = true;
  #     javaPath = "${pkgs.jdk8}";
  #   };
  # };
  # xdg.desktopEntries = {
  #   rocket-league = {
  #     categories = [ "Game" ];
  #     exec = "xdg-open heroic://launch/legendary/Sugar";
  #     icon = "/home/getpsyched/.config/heroic/icons/Sugar.jpg";
  #     name = "Rocket League";
  #     terminal = false;
  #     type = "Application";
  #   };
  # };
}
