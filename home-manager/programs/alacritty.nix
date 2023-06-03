{ pkgs, config, ... }:

{
  programs.alacritty =
    {
      enable = true;
      settings = {
        env.TERM = "alacritty";
        window = {
          decorations = "full";
          title = "Alacritty";
          dynamic_title = true;
          opacity = 0.8;
          class = {
            instance = "Alacritty";
            general = "Alacritty";
          };
        };
        font = {
          normal = {
            family = "Noto Sans Mono";
            style = "Regular";
          };
          bold = {
            family = "Noto Sans Mono";
            style = "Bold";
          };
          italic = {
            family = "Noto Sans";
            style = "Italic";
          };
          bold_italic = {
            family = "Noto Sans";
            style = "Bold Italic";
          };
          size = config.appearance.fontSize;
        };
        colors = {
          primary = {
            background = "#1d1f21";
            foreground = "#c5c8c5";
          };
        };
      };
    };
}
