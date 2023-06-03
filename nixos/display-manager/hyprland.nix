{ inputs, outputs, lib, config, pkgs, ... }: {

  nix.settings.substituters = [ "https://hyprland.cachix.org" ];
  nix.settings.trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # Auto Login
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "mrtn";
      };
      default_session = initial_session;
    };
  };

  security.pam.services.swaylock = {
    text = "auth include login";
  };

}
