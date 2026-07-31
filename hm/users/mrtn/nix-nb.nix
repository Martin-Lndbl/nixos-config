{
  pkgs,
  config,
  ...
}:

let
  tabletModeWatcher = pkgs.writeShellApplication {
    name = "wayle-tablet-mode-watch";
    runtimeInputs = with pkgs; [
      evtest
      gawk
      wayle
    ];
    text = ''
      dev=$(awk -v RS= '/Tablet Mode/{
        match($0, /event[0-9]+/)
        print "/dev/input/" substr($0, RSTART, RLENGTH)
        exit
      }' /proc/bus/input/devices)

      if [ -z "$dev" ]; then
        echo "No tablet-mode switch found in /proc/bus/input/devices" >&2
        exit 1
      fi

      apply() {
        if [ "$1" = "1" ]; then
          wayle config set bar.location top
        else
          wayle config set bar.location bottom
        fi
      }

      stdbuf -oL evtest "$dev" | while IFS= read -r line; do
        case "$line" in
          *"SW_TABLET_MODE) state 1"*)  apply 1 ;;  # initial state at startup
          *"SW_TABLET_MODE) state 0"*)  apply 0 ;;
          *"SW_TABLET_MODE), value 1"*) apply 1 ;;  # runtime flip
          *"SW_TABLET_MODE), value 0"*) apply 0 ;;
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
  systemd.user.services.wayle-tablet-mode = {
    Unit.Description = "Flip wayle bar location on tablet-mode change";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${tabletModeWatcher}/bin/wayle-tablet-mode-watch";
      Restart = "on-failure";
    };
  };

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
