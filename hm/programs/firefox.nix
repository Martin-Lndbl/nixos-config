{ config, ... }:

{
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  stylix.targets.firefox.enable = false;
  stylix.targets.firefox.profileNames = [ ];

  wayland.windowManager.hyprland.settings.window_rule = [
    # Downloads
    {
      match.title = "^(Save)(.*)$";
      size = "800 400";
    }
    {
      match.title = "^(Save)(.*)$";
      float = true;
    }

    {
      match = {
        title = "^(Choose a color)$";
        class = "^(firefox)$";
      };
      size = "488 316";
    }

    # Popups
    {
      match = {
        title = "^((?!Save)(?!Mozilla firefox).)*$";
        class = "^(firefox)$";
      };
      size = "50% 50%";
    }

    # Streaming
    {
      match.title = "^(Netflix — Mozilla Firefox)";
      opacity = 1;
    }
  ];
}
