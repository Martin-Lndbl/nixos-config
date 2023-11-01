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
          padding.x = 4;
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
            family = "Noto Sans Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "Noto Sans Mono";
            style = "Bold Italic";
          };
          size = config.appearance.fontSize;
        };
        colors = {
          primary = {
            background = "#${config.colorscheme.colors.base00}";
            foreground = "#${config.colorscheme.colors.base07}";
          };
        };
      };
    };
}
