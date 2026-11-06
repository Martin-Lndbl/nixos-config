{ config, pkgs, ... }:
let
  # SDDM ran hyprland.desktop, i.e. start-hyprland, through its wayland-session
  # wrapper -- which for bash is just "exec $SHELL --login". Reproduce that.
  # Deliberately not uwsm: it expects the session to call "uwsm finalize",
  # which this Hyprland config never does, so HYPRLAND_INSTANCE_SIGNATURE never
  # reaches the activation environment and the session gets torn down.
  # graphical-session.target comes from home-manager's hyprland-session.target.
  sessionScript = pkgs.writeShellScript "hyprland-session" ''
    exec ${config.programs.hyprland.package}/bin/start-hyprland
  '';
  session = "${pkgs.bash}/bin/bash --login ${sessionScript}";
in
{
  imports = [ ./greetd.nix ];

  services.greetd.settings = {
    # No greeter: boot goes straight into the session. default_session is
    # required, and is what greetd falls back to after logout.
    initial_session = {
      command = session;
      user = "mrtn";
    };
    default_session = {
      command = session;
      user = "mrtn";
    };
  };
}
