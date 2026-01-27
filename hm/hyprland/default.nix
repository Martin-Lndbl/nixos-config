{
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./wofi.nix
    ./grim.nix
  ];

  stylix.targets.hyprland.enable = true;
  stylix.targets.hyprpanel.enable = true;
  programs.hyprpanel = {
    enable = true;
    settings = {
      bar.bluetooth.label = false;
      bar.clock.format = "%d.%m | %H:%M:%S";
      theme = {
        font.size = "16px";
        bar.transparent = true;
        bar.location = "bottom";
      };
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
    hyprctl-rotate
  ];

  programs.hyprlock.enable = true;
  stylix.targets.hyprlock.colors.enable = true;

  programs.bash.bashrcExtra = ''
    ccat() {
      cat "$1" | wl-copy
    }
  '';
  programs.bash.shellAliases = {
    cpwd = "pwd | wl-copy";
  };

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
