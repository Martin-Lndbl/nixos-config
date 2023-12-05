{ pkgs, ... }:

{
  programs.firefox.enable = true;

  xdg.desktopEntries.firefox = {
    name = "Firefox";
    genericName = "Web Browser";
    exec = "firefox %U";
    terminal = false;
    categories = [ "Application" "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    #	Popups
    windowrulev2 = size 578 187, title:^((?!Save)(?!Mozilla firefox).)*$,floating:1,class:^(firefox)$
    
    #	Downloads
    windowrulev2 = size 800 400, title:^(Save)(.*)$, floating:1

    # Color
    windowrulev2 = size 488 316, title:^(Choose a color)$, floating:1, class:^(firefox)$
  '';

}
