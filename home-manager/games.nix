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
}
