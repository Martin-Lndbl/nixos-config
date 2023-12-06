{ pkgs, config, lib, ... }:

{
  programs.waybar =
    {
      enable = true;
      style = import ./style.nix { inherit config; };
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = config.appearance.fontSize * 3;
          output = lib.attrValues config.monitors;

          modules-left = [
            "hyprland/workspaces"
            # "hyprland/window"
            # "wlr/taskbar"
          ];
          modules-center = [
            "clock"
          ];

          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "disk"
            "battery"
            # "temperature"
          ];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            on-click = "activate";
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "10" = "10";
            };
          };
          "wlr/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };

          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 24;
            icon-theme = "Fluent";
            tooltip-format = "{title}";
            on-click = "activate";
            on-click-middle = "close";
          };

          "pulseaudio" = {
            format = "🔊 {volume}%";
            format-muted = "🔈 {volume}%";
          };

          "network" = {
            format = "Disabled";
            format-wifi = "WIFI: {essid}";
            format-ethernet = "E: {ipaddr}";
            format-disconnected = "Disconnected";
          };
          "cpu" = {
            format = "CPU: {usage}%";
            on-click = "alacritty -e htop";
          };
          "memory" = {
            format = "RAM: {}%";
            on-click = "alacritty -e htop";
          };
          "clock" = {
            format = "{:%a %d %b - %H:%M}";
            interval = 1;
          };
          "disk" = {
            format = "{free}";
          };

          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "🔋 {capacity: >3}%";
            format-charging = "⚡{capacity}%";
          };
        };
      };
    };
}
