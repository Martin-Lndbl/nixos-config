{ pkgs, lib, inputs, ... }:

{
  imports = [ inputs.qylock.nixosModules.default ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = lib.mkDefault true;
    wayland.compositor = lib.mkDefault "kwin";
    settings = {
      Theme = {
        CursorTheme = "phinger-cursors-light";
        CursorSize = 28;
      };
    };
  };
  services.displayManager.defaultSession = "hyprland";

  security.pam.services.sddm.enableGnomeKeyring = true;

  programs.qylock = {
    enable = true;
    theme = "pixel-dusk-city";
  };

  environment.systemPackages = [ pkgs.phinger-cursors ];
}
