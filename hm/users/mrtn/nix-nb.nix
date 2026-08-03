{
  pkgs,
  config,
  ...
}:

let
  tabletModeWatcher = pkgs.writeShellApplication {
    name = "tablet-mode-watch";
    runtimeInputs = with pkgs; [ evtest gawk ];
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

      state_file="$XDG_RUNTIME_DIR/tablet-mode"

      apply() {
        if [ "$1" = "1" ]; then
          touch "$state_file"
        else
          rm -f "$state_file"
        fi
      }

      stdbuf -oL evtest "$dev" | while IFS= read -r line; do
        case "$line" in
          *"SW_TABLET_MODE) state 1"*)  apply 1 ;;
          *"SW_TABLET_MODE) state 0"*)  apply 0 ;;
          *"SW_TABLET_MODE), value 1"*) apply 1 ;;
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
    wvkbd
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd(
      [[sh -c 'pkill -x wvkbd-mobintl || wvkbd-mobintl -L 250 &']]))
  '';

  appearance.wallpaper = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/cozy-winterscape-3840x2160-21319.jpg";
    hash = "sha256-knweYThXi1bhUBz2sjjdwhbyRE5Jni1y9A1TWIbO0do=";
  };
  appearance.opacity = 0.95;
  appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  appearance.fontSize = 14;
  appearance.hasBattery = true;
  monitors.center = "eDP-1";

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = monitors.center;
      mode = "1920x1080@60";
      position = "-1920x1080";
      scale = 1;
    }
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
      mirror = "eDP-1";
    }
  ];
  systemd.user.services.tablet-mode = {
    Unit.Description = "Track tablet-mode switch state in $XDG_RUNTIME_DIR/tablet-mode";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${tabletModeWatcher}/bin/tablet-mode-watch";
      Restart = "on-failure";
    };
  };
}
