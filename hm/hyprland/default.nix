{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./caelestia.nix
    ./grimblast.nix
    ./border-colour.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    gpu-screen-recorder
  ];
  home.pointerCursor.enable = true;

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

  # home.sessionVariables only ever reach a login shell. Hyprland inherits them
  # (greetd runs the session through "bash --login"), so anything Hyprland
  # spawns itself is fine -- but the systemd user manager is started by PAM
  # before any of that and never sees them. Everything launched out of a user
  # unit, which includes anything started from the caelestia launcher, is
  # therefore missing XCURSOR_SIZE/XCURSOR_THEME and NIXOS_OZONE_WL: Xwayland
  # clients such as Steam and Discord fall back to libXcursor's default size of
  # screen height / 48, i.e. 45px on these 4K monitors instead of 28.
  #
  # uwsm would normally import these, but autologin.nix deliberately does not
  # use it. Writing them to environment.d gets them into the user manager at
  # session start instead.
  systemd.user.sessionVariables = config.home.sessionVariables;
}
