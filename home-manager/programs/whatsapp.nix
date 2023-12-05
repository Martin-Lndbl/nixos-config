{ pkgs, ... }:

{
  home.packages = with pkgs; [
    whatsapp-for-linux
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    windowrulev2=fakefullscreen,class:^(whatsapp-for-linux)$
  '';

}
