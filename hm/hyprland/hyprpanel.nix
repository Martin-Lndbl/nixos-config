{
  pkgs,
  lib,
  config,
  ...
}:
{

  home.packages = with pkgs; [
    btop
  ];

  services.wayle = {
    enable = true;

    autoInstallDependencies = true;

    settings = {
      bar = {
        location = "bottom";
        bg = "transparent";
        scale = 0.9;
        button-variant = "basic";
        button-bg-opacity = 0;
      };
      osd.enabled = false;
      modules = {
        clock = {
          format = "%H:%M:%S";
          dropdown-show-seconds = false;
        };
        weather = {
          location = "Munich";
          units = "metric";
        };
        volume = {
          scroll-up = "wayle audio output-volume +2";
          scroll-down = "wayle audio output-volume -2";
        };
        microphone = {
          scroll-up = "wayle audio input-volume +2";
          scroll-down = "wayle audio input-volume -2";
        };
        notifications = {
          popup-duration = 3500;
          popup-position = "top-right";
          popup-max-visible = 5;
        };
        custom = [
          {
            id = "cpu-temp";
            command = "${pkgs.lm_sensors}/bin/sensors | sed -n 's/^Tctl: *+\\([0-9.]*\\)°C.*/\\1°C/p'";
            interval-ms = 2000;
            icon-name = "ld-thermometer-symbolic";
            format = "{{ output }}";
          }
          {
            id = "screenshot";
            icon-name = "ld-camera-symbolic";
            left-click = "${pkgs.grimblast}/bin/grimblast copy area";
            interval-ms = 0;
            tooltip-format = "Screenshot area (left-click)";
          }
        ];
      };
      styling.palette = with config.lib.stylix.colors; {
        bg = "#${base00}";
        surface = "#${base01}";
        elevated = "#${base02}";
        fg = "#${base05}";
        fg_muted = "#${base03}";
        primary = "#${base0D}";
        red = "#${base08}";
        yellow = "#${base0A}";
        green = "#${base0B}";
        blue = "#${base0D}";
      };
      wallpaper.engine-enabled = false;
    };
  };
}
