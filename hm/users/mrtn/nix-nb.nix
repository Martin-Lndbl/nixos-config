{
  pkgs,
  config,
  ...
}:

let
  tabletModeWatcher = pkgs.writeShellApplication {
    name = "wayle-tablet-mode-watch";
    runtimeInputs = with pkgs; [
      glib
      systemd
      wayle
    ];
    text = ''
      set_location() {
        if [ "$1" = "true" ]; then
          wayle config set bar.location bottom
        else
          wayle config set bar.location top
        fi
      }

      # Set correct location on startup
      current="$(busctl --system get-property net.hadess.SensorProxy \
        /net/hadess/SensorProxy net.hadess.SensorProxy TabletMode 2>/dev/null \
        | awk '{print $2}')"
      set_location "''${current:-false}"

      # React to flips as they happen
      gdbus monitor --system --dest net.hadess.SensorProxy \
        --object-path /net/hadess/SensorProxy |
      while read -r line; do
        case "$line" in
          *"'TabletMode': <true>"*)  set_location true ;;
          *"'TabletMode': <false>"*) set_location false ;;
        esac
      done
    '';
  };
in
rec {
  imports = [ ./secrets.nix ];

  home.packages = with pkgs; [
    prismlauncher
    iio-sensor-proxy
    iio-hyprland
  ];

  appearance.wallpaper = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/cozy-winterscape-3840x2160-21319.jpg";
    hash = "sha256-knweYThXi1bhUBz2sjjdwhbyRE5Jni1y9A1TWIbO0do=";
  };
  appearance.opacity = 0.95;
  appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  appearance.fontSize = 14;
  appearance.hasBattery = true;
  monitors.center = "eDP-1";

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "${monitors.center}, 1920x1080@60, -1920x1080, 1"
      " , preferred, auto, 1, mirror, eDP-1"
    ];
  };
  # systemd.user.services.wayle-tablet-mode = {
  #   Unit.Description = "Flip wayle bar location on tablet-mode change";
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service = {
  #     ExecStart = "${tabletModeWatcher}/bin/wayle-tablet-mode-watch";
  #     Restart = "on-failure";
  #   };
  # };

  services.wayle.settings.bar = {
    scale = 0.7;
    layout = [
      {
        monitor = config.monitors.center;
        show = true;
        left = [
          "dashboard"
          "hyprland-workspaces"
        ];
        center = [
          "clock"
        ];
        right = [
          "cpu"
          "ram"
          "storage"
          "custom-cpu-temp"
          # "seperator"
          "network"
          "volume"
          "microphone"
          "notifications"
        ];
      }
    ];
  };

}
