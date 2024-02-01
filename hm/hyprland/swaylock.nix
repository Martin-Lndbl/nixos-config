{ pkgs, config, ... }:

{
  programs.swaylock = with config.colorScheme.palette; {
    enable = true;
    settings = {
      image = builtins.toString config.appearance.lockScreen;
      font-size = 18;
      indicator-idle-visible = false;
      indicator-radius = 60;
      show-failed-attemps = true;
      inside-color = base00;
      key-hl-color = base05;
      ring-color = base02;
    };
  };
}
