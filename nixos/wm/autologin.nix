{ config, pkgs, ... }:
let
  # Hardcode-mode uwsm launch: same session uwsm would build from
  # hyprland.desktop, but without depending on XDG_DATA_DIRS being populated
  # in greetd's context. caelestia runs as a user unit, so the uwsm-managed
  # graphical-session.target has to stay.
  session = "${pkgs.uwsm}/bin/uwsm start -e -D Hyprland -N Hyprland ${config.programs.hyprland.package}/bin/Hyprland";
in
{
  services.greetd = {
    enable = true;
    settings = {
      # No greeter: boot goes straight into the session. default_session is
      # what greetd falls back to after logout, so point it at the same thing.
      initial_session = {
        command = session;
        user = "mrtn";
      };
      default_session = {
        command = session;
        user = "mrtn";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
