{ ... }:

{
  stylix.targets.fuzzel.enable = true;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty";
        layer = "overlay";
        width = 50;
        lines = 15;
        prompt = "'Apps '";
        icon-theme = "Papirus";
        show-actions = "no";
      };
      border = {
        radius = 8;
        width = 0;
      };
    };
  };
}
