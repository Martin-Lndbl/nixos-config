{ pkgs, lib, ... }:

{
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.hyprlock.enable = true;

  # `programs.hyprlock.enable` implicitly turns on `services.hypridle`, which
  # then crash-loops without a hypridle.conf. Locking is triggered manually
  # (SUPER+ALT+L binding), so keep the daemon off.
  services.hypridle.enable = lib.mkForce false;

  nix.settings.substituters = [ "https://hyprland.cachix.org" ];
  nix.settings.trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      "Hyprland" = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      "common" = {
        default = [ "gtk" ];
      };
    };
  };
}
