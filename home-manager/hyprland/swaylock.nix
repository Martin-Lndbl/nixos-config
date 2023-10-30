{ pkgs, config, ... }:

{
  programs.swaylock =
    {
      settings = {
        image = builtins.toString config.appearance.lockScreen;
        font-size = 18;
        indicator-idle-visible = false;
        indicator-radius = 60;
        show-failed-attemps = true;
        inside-color = config.colorScheme.colors.base00;
        key-hl-color = config.colorScheme.colors.base08;
        ring-color = config.colorScheme.colors.base07;
      };
    };
}
