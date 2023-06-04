{ inputs, outputs, lib, config, pkgs, ... }:
{
  programs = {
    swaylock = import ./swaylock.nix { inherit pkgs; };

    waybar = import ./waybar { inherit pkgs; };

    wofi.enable = true;
  };

  services.mako.enable = true;

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.conf".source = import ./hyprland.nix { inherit pkgs config; };

  xdg.configFile."wofi/style.css".source = ./wofi.css;
}
