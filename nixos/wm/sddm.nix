# SDDM greeter. Both the GNOME (`nixos/wm/gnome.nix`) and Hyprland
# (`nixos/wm/hyprland.nix`) sessions register with the display manager,
# so the user can pick either one from the login screen's session menu.
# `defaultSession` controls which is preselected.
{ pkgs, ... }:

let
  # Catppuccin Mocha (dark) with the "blue" accent. The package derives its
  # theme directory name from the flavor + accent, so it becomes
  # `catppuccin-mocha-blue` — that's the value passed to sddm.theme below.
  catppuccinTheme = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "blue";
    font = "JetBrains Mono";
    fontSize = "12";
    loginBackground = true;
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha-blue";
    extraPackages = [
      catppuccinTheme
      pkgs.kdePackages.qtsvg
    ];
    settings = {
      General = {
        CursorTheme = "phinger-cursors-light";
        CursorSize = 28;
      };
    };
  };
  services.displayManager.defaultSession = "hyprland";

  # Ship the cursor theme and the SDDM theme system-wide so they are
  # discoverable by the `sddm` system user.
  environment.systemPackages = [
    pkgs.phinger-cursors
    catppuccinTheme
  ];
}
