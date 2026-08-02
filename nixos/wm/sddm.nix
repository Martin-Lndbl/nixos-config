# SDDM greeter. Both the GNOME (`nixos/wm/gnome.nix`) and Hyprland
# (`nixos/wm/hyprland.nix`) sessions register with the display manager,
# so the user can pick either one from the login screen's session menu.
# `defaultSession` controls which is preselected.
{ pkgs, inputs, ... }:

{
  imports = [ inputs.qylock.nixosModules.default ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      # SDDM on Wayland reads the cursor from [Theme], not [General].
      # https://discourse.nixos.org/t/sddm-ignoring-cursor-theming/71645
      Theme = {
        CursorTheme = "phinger-cursors-light";
        CursorSize = 28;
      };
    };
  };
  services.displayManager.defaultSession = "hyprland";

  # qylock ships a collection of SDDM themes; its NixOS module wires the
  # selected one into `services.displayManager.sddm.theme` and adds the
  # required Qt6/QML packages to `extraPackages`.
  # Theme directory names live under https://github.com/Darkkal44/qylock/tree/main/themes
  programs.qylock = {
    enable = true;
    theme = "nier-automata";
    quickshell.enable = false; # not using qylock's lockscreen; hyprlock covers that
  };

  environment.systemPackages = [ pkgs.phinger-cursors ];
}
