{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./eww
    ./swaylock.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
  ];

  services.mako.enable = true; # Notifications

  programs.wofi.enable = true; # Application launcher
  xdg.configFile."wofi/style.css".source = ./wofi.css;

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
}
