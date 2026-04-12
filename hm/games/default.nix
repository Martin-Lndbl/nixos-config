{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    gamescope
    steam
    prismlauncher
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    windowrulev2 = opacity 1, title:(SevTech Ages)
  '';
}
