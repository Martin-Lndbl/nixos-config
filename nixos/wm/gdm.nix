# GDM greeter. Both the GNOME (`nixos/wm/gnome.nix`) and Hyprland
# (`nixos/wm/hyprland.nix`) sessions register with the display manager,
# so the user can pick either one from the login screen's session menu.
# `defaultSession` controls which is preselected.
{ ... }:

{
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";
}
