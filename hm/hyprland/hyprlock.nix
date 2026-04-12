{ config, lib, ... }:
let
  hexToRgbA =
    with lib.string;
    hex:
    let
      r = toInt (substring 0 2 hex) 16;
      g = toInt (substring 2 4 hex) 16;
      b = toInt (substring 4 6 hex) 16;
      a = 100;
    in
    "rgba(${toString r}, ${toString g}, ${toString b}, ${toString a})";
in
{
  stylix.targets.hyprlock.enable = false;
  stylix.targets.hyprlock.colors.enable = false;
  programs.hyprlock = {
    enable = true;
    extraConfig = with config.lib.stylix.colors; ''
      $base = "#${base0A}"
      $accent = "#${base0E}"
      $accentAlpha = "#${base07}"
      $text = "#${base01}"

      general {
          hide_cursor = true
      }

      background {
          monitor =
          path = ${config.appearance.wallpaper}
          blur_passes = 2
          color = $base
      }

      label {
          monitor =
          text = cmd[update:30000] echo "$(date +"%R")"
          color = $text
          font_size = 90
          position = 0, 150
          halign = center
          valign = center
      }

      label {
          monitor = 
          text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
          color = $text
          font_size = 25
          position = 0, 50
          halign = center
          valign = center
      }

      input-field {
          monitor =
          size = 300, 60
          outline_thickness = 4
          dots_size = 0.2
          dots_spacing = 0.2
          dots_center = true
          outer_color = $accent
          inner_color = "#${base08}"
          font_color = $text
          fade_on_empty = false
          placeholder_text = <span><i>Password...</i></span>
          hide_input = false
          check_color = $accent
          fail_color = "#${base04}"
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
          capslock_color = $yellow
          position = 0, -35
          halign = center
          valign = center
      }
    '';
  };
}
