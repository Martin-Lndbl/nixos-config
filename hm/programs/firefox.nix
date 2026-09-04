{ config, pkgs, ... }:

let
  # Restored tabs (calendar) only resolve through the pyroeis tunnel, same race
  # as thunderbird/feishin in ../hyprland/hyprland.nix. Patched into the shipped
  # entry rather than written out here so the Exec lines cannot drift from the
  # package; $XDG_DATA_HOME wins over the profile's share/applications. The
  # SUPER + g bind carries its own copy of the wait.
  firefoxDesktop = pkgs.runCommand "firefox-wait-for-pyroeis.desktop" { } ''
    substitute ${config.programs.firefox.finalPackage}/share/applications/firefox.desktop $out \
      --replace-fail "Exec=firefox" "Exec=${pkgs.wait-for-pyroeis}/bin/wait-for-pyroeis firefox"
  '';
in
{
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  xdg.dataFile."applications/firefox.desktop".source = firefoxDesktop;

  wayland.windowManager.hyprland.settings.window_rule = [
    # Downloads
    {
      match.title = "^(Save)(.*)$";
      size = "800 400";
      float = true;
    }

    {
      match = {
        title = "^(Choose a color)$";
        class = "^(firefox)$";
      };
      size = "488 316";
    }

    # Streaming
    {
      match.title = "^(Netflix — Mozilla Firefox)";
      opacity = 1;
    }
  ];
}
