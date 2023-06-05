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
        inside-color = "ffffff00";
        key-hl-color = "153B3099";
        ring-color = "3B3B3999";
      };
    };
}
