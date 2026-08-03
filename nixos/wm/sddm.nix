{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    theme = "Elegant";
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
      kdePackages.qt5compat
    ];
    settings = {
      Theme = {
        CursorTheme = "phinger-cursors-light";
        CursorSize = 28;
      };
    };
  };
  services.displayManager.defaultSession = "hyprland";

  security.pam.services.sddm.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    phinger-cursors
    elegant-sddm
  ];
}
