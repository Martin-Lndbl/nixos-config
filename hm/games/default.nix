{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    prismlauncher
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    windowrulev2 = opacity 1, title:(SevTech Ages)
  '';
}
