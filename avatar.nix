# Single source of truth for the profile picture: used both by home-manager
# (~/.face) and by the SDDM greeter, which must not drift apart.
pkgs:
pkgs.fetchurl {
  url = "https://avatars.githubusercontent.com/u/77677509?v=4";
  hash = "sha256-xUB6FICXhoX8lK/tZI9yiVAY2VFuKXePwGnhQhKHWg0=";
}
