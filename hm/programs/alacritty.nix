{ config, lib, ... }:

{
  stylix.targets.alacritty.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
        padding.x = 4;
      };
    };
  };
}
