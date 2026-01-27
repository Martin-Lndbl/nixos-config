{ ... }:

{
  programs.firefox.enable = true;

  stylix.targets.firefox.enable = false;
  stylix.targets.firefox.profileNames = [ ];

  xdg.desktopEntries.firefox = {
    name = "Firefox";
    genericName = "Web Browser";
    exec = "firefox %U";
    terminal = false;
    categories = [
      "Application"
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    #	Downloads
    windowrulev2 = size 800 400, title:^(Save)(.*)$, floating:1

    # Color
    windowrulev2 = size 488 316, title:^(Choose a color)$, floating:1, class:^(firefox)$

    #	Popups
    windowrulev2 = size 50% 50%, title:^((?!Save)(?!Mozilla firefox).)*$,floating:1,class:^(firefox)$

    # Streaming
    windowrulev2 = opacity 1, title:^(Netflix — Mozilla Firefox)
    windowrulev2 = opacity 1, title:^(TUM-Live).*
    windowrulev2 = opacity 1, title:^.*(YouTube — Mozilla Firefox)
  '';

}
