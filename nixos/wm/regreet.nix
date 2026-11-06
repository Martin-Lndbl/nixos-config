# A login screen with a choice of user (see ../guest.nix). ReGreet only shows
# a password field once PAM actually asks for one, so the passwordless guest
# logs in straight away; SDDM's theme always shows the field. greetd runs the
# chosen session after sourcing /etc/profile and ~/.profile, which is where
# home-manager's session variables come from.
{ ... }:
let
  # ReGreet remembers the last session per user, keyed by the session's Name=.
  # Seeded so the guest lands in Plasma rather than whatever was used last,
  # and rewritten every boot so a session picked by accident does not stick.
  state = ''
    last_user = "mrtn"

    [user_to_last_sess]
    mrtn = "Hyprland"
    guest = "Plasma (Wayland)"
  '';
in
{
  imports = [ ./greetd.nix ];

  services.displayManager.regreet = {
    enable = true;
    # cage otherwise spreads the greeter across every output, the TV
    # included. The TV connects first at boot, so "last" is a desk monitor.
    cageArgs = [
      "-s"
      "-d"
      "-m"
      "last"
    ];
    settings.GTK.application_prefer_dark_theme = true;
  };

  systemd.tmpfiles.settings."10-regreet"."/var/lib/regreet/state.toml"."f+" = {
    user = "greeter";
    group = "greeter";
    mode = "0644";
    argument = state;
  };
}
