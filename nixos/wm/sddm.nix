{ pkgs, ... }:

let
  avatar = pkgs.fetchurl {
    url = "https://avatars.githubusercontent.com/u/77677509?v=4";
    hash = "sha256-xUB6FICXhoX8lK/tZI9yiVAY2VFuKXePwGnhQhKHWg0=";
  };
  facesDir = pkgs.runCommand "sddm-faces" { } ''
    mkdir -p $out
    cp ${avatar} $out/mrtn.face.icon
    cp ${avatar} $out/.face.icon
  '';
in
{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    theme = "Elegant";
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qt5compat
    ];
    settings = {
      Theme = {
        CursorTheme = "phinger-cursors-light";
        CursorSize = 28;
        FacesDir = "${facesDir}";
      };
      General = {
        InputMethod = "";
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
