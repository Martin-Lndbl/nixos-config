{ config, pkgs, ... }:

let
  # Profile used by firefox-vpn (see nixos/airvpn.nix). It is launched with an
  # explicit --profile path and deliberately not declared under
  # programs.firefox.profiles: that would make home-manager own profiles.ini,
  # and the existing default and autostart profiles would have to be
  # redeclared to survive. Extensions are seeded the way the module does it
  # anyway: the xpi symlinked into the profile's extensions directory, and
  # autoDisableScopes=0 so Firefox enables it without asking. Firefox updates
  # the installed copy on its own afterwards; the pin is only the seed, and
  # `force` lets activation replace whatever Firefox left there.
  vpnProfile = "${config.programs.firefox.configPath}/vpn";

  ublockOrigin = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/5034826/ublock_origin-1.75.0.xpi";
    hash = "sha256-W3RBWGBFY3BkS9gPFhJehlsObDVrtd/PuEBpln6qUoc=";
  };
in
{
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  home.file = {
    "${vpnProfile}/extensions/uBlock0@raymondhill.net.xpi" = {
      source = ublockOrigin;
      force = true;
    };
    "${vpnProfile}/user.js".text = ''
      user_pref("extensions.autoDisableScopes", 0);
    '';
  };

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
