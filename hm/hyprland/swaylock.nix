{ pkgs, config, ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      image = builtins.toString config.appearance.lockScreen;
      font-size = 18;
      indicator-idle-visible = false;
      indicator-radius = 60;
      show-failed-attemps = true;
      inside-color = config.colorScheme.colors.base00;
      key-hl-color = config.colorScheme.colors.base05;
      ring-color = config.colorScheme.colors.base02;
    };
  };
}
