{ pkgs, ... }:

{
  programs.i3status =
    {
      enable = true;
      enableDefault = false;

      general = {
        colors = true;
        color_good = "#e0e0e0";
        color_degraded = "#d7ae00";
        color_bad = "#f69d6a";
        interval = 1;
      };

      modules = {
        "volume master" = {
          position = 1;
          settings = {
            format = "🔊 %volume";
            format_muted = "🔈 (%volume)";
            device = "pulse";
          };
        };

        "disk /" = {
          position = 7;
          settings = {
            format = "%avail free";
          };
        };

        "ipv6" = {
          position = 2;
        };

        "wireless _first_" = {
          position = 4;
          settings = {
            format_down = "W: down";
            format_up = "%essid:%quality";
          };
        };
        "battery all" = {
          position = 9;
          settings = {
            format = "%status%percentage";
            format_down = "";
            last_full_capacity = true;
            integer_battery_capacity = true;
            low_threshold = 15;
            threshold_type = "percentage";
            hide_seconds = true;
            status_chr = "⚡";
            status_bat = "🔋";
          };
        };
        "ethernet _first_" = {
          position = 3;
          settings = {
            format_down = "E: down";
            format_up = "E: %ip (%speed)";
          };
        };
        "tztime local" = {
          position = 8;
          settings.format = "%A, %d.%m - %H:%M:%S";
        };
        "cpu_usage" = {
          position = 6;
          settings.format = "%usage CPU";
        };
        /* "cpu_temperature 0" = { */
        /* position = ; */
        /* settings.format = "%degrees°C"; */
        /* }; */
        "memory" = {
          position = 5;
          settings = {
            format = "%used RAM";
            unit = "Gi";
          };
        };
      };
    };
}
