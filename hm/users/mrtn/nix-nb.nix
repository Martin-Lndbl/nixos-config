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

      # Expose tablet-mode state to other processes as a sentinel file.
      # The wayle `keyboard` custom module (defined below) uses its presence
      # to decide whether to show itself in the bar.
      state_file="$XDG_RUNTIME_DIR/tablet-mode"

      apply() {
        if [ "$1" = "1" ]; then
          wayle config set bar.location top
          touch "$state_file"
        else
          wayle config set bar.location bottom
          rm -f "$state_file"
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
    wvkbd # on-screen keyboard for tablet mode; toggle bind below
  ];

  # Toggle wvkbd on-screen keyboard (SUPER + ALT + K).
  # wvkbd is a Wayland layer-shell keyboard — no windowrule needed.
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
  systemd.user.services.wayle-tablet-mode = {
    Unit.Description = "Flip wayle bar location on tablet-mode change";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${tabletModeWatcher}/bin/wayle-tablet-mode-watch";
      Restart = "on-failure";
    };
  };

  # nix-nb-only keyboard toggle module. `hide-if-empty = true` + the command
  # reading the tablet-mode sentinel file makes it appear only in tablet mode.
  services.wayle.settings.modules.custom = [
    {
      id = "keyboard";
      command = ''sh -c '[ -f "$XDG_RUNTIME_DIR/tablet-mode" ] && echo 1' '';
      interval-ms = 1000;
      hide-if-empty = true;
      icon-name = "ld-keyboard-symbolic";
      left-click = "sh -c 'pkill -x wvkbd-mobintl || wvkbd-mobintl -L 250 &'";
      tooltip-format = "Toggle on-screen keyboard";
    }
  ];

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
          "custom-screenshot"
          "clock"
          "custom-keyboard"
        ];
        right = [
          "cpu"
          "ram"
          "storage"
          "custom-cpu-temp"
          "network"
          "volume"
          "microphone"
          "brightness"
          "battery"
          "notifications"
        ];
      }
    ];
  };

}
