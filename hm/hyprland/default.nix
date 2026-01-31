{
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./wofi.nix
    ./grim.nix
  ];

  stylix.targets.hyprland.enable = true;
  home.packages = with pkgs; [
    wl-clipboard
    hyprctl-rotate
  ];

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
