{ config, ... }:

{
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  wayland.windowManager.hyprland.settings.window_rule = [
    # Downloads
    {
      match.title = "^(Save)(.*)$";
      size = "800 400";
      float = true;
    }

    {
      match = {
        title = "^(Choose a color)$";
        class = "^(firefox)$";
      };
      size = "488 316";
    }

    # Streaming
    {
      match.title = "^(Netflix — Mozilla Firefox)";
      opacity = 1;
    }
  ];
}
