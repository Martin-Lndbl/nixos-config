{ pkgs, ... }:

{
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  programs.ssh.enableAskPassword = true;
  programs.ssh.askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";

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
