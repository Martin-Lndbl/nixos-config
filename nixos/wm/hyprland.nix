{ inputs, outputs, lib, config, pkgs, ... }:
let
  swayConfig = pkgs.writeText "greetd-sway-config"
    ''
      input * xkb_layout de
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
      exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${./gtkgreet.css}; swaymsg exit"
      bindsym Mod4+shift+e exec swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'
    '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
    bash
  '';

  nix.settings.substituters = [ "https://hyprland.cachix.org" ];
  nix.settings.trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        "Hyprland" = {
          default = [ "hyprland" "gtk" ];
        };
        "common" = {
          default = [ "gtk" ];
        };
      };
    };
  };

  console.keyMap = lib.mkForce "de-latin1";

  security.pam.services.swaylock = {
    text = "auth include login";
  };
}
