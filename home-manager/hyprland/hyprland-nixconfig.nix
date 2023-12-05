{ pkgs, config, ... }:

let
  workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];

  switch_workspace = builtins.map
    (ws: "SUPER, ${ws}, workspace, ${ws}")
    workspaces;

  move_workspace = builtins.map
    (ws: "SUPER_SHIFT, ${ws}, movetoworkspace, ${ws}")
    workspaces;

  eww_trigger_ws =
    (builtins.map
      (ws: "SUPER, ${ws}, exec, XDG_CONFIG_HOME/eww/scripts/workspaces ${ws}")
      workspaces) ++
    (builtins.map
      (ws: "SUPER, ${ws}, exec, XDG_CONFIG_HOME/eww/scripts/workspaces ${ws}")
      workspaces
    );
in
{
  config.wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swaybg -i ${config.appearance.wallpaper}"
      "${pkgs.eww} open bar"
      "[workspace 9 silent; noanim; fakefullscreen]
        firefox https://outlook.live.com/calendar/0/view/week"
      "[workspace 9 silent; noanim] whatsapp-for-linux"
      "[workspace 1; noanim] alacritty"
      "[workspace 1; noanim] alacritty"
    ];

    input = {
      kb_layout = "de";
      follow_mouse = 1;
    };

    monitor = [
      "eDP-1, 1920x1080@60,0x0,1"
      ",highres,auto,1"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      resize_on_border = true;
      col.active_border = config.colorScheme.colors.base06;
      col.inactive_border = config.colorScheme.colors.base02;
    };

    goup.col = {
      border_active = config.colorScheme.colors.base0C;
      border_inactive = config.colorScheme.colors.base0D;
    };

    decoration = {
      rounding = 5;
      blur = {
        enable = true;
        size = 3;
        passes = 2;
      };
    };

    animations = {
      enabled = 1;
      animation = [
        "windows,1,7,default"
        "workspaces,1,6,default"
      ];
    };

    dwindle = {
      pseudotile = true;
      force_split = 2;
      preserve_split = true;
    };

    master.new_is_master = true;

    bind = [
      # App binds
      "SUPER, return, exec, alacritty"
      "SUPER, d, exec, wofi --show drun"
      "SUPER, g, exec, MOZ_ENABLE_WAYLAND=1 firefox"
      "SUPER_SHIFT, Q, killactive"
      "SUPERALT, L, exec, swaylock -fel"
      "SUPERALT, S, exec, swaylock -fel; sleep 1; systemctl suspend -i"

      # Move focus
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      "SUPER, h, movefocus, l"
      "SUPER, l, movefocus, r"
      "SUPER, k, movefocus, u"
      "SUPER, j, movefocus, d"

      "SUPER_SHIFT, left, movewindow, l"
      "SUPER_SHIFT, right, movewindow, r"
      "SUPER_SHIFT, up, movewindow, u"
      "SUPER_SHIFT, down, movewindow, d"

      "SUPER_SHIFT, h, movewindow, l"
      "SUPER_SHIFT, l, movewindow, r"
      "SUPER_SHIFT, k, movewindow, u"
      "SUPER_SHIFT, j, movewindow, d"

      "SUPER, q, togglesplit,"
      "SUPER, v, togglefloating,"
      "SUPER, v, centerwindow,"
      "SUPER, f, fullscreen,"
      "SUPER_SHIFT, f, fakefullscreen"

      # Groups
      "SUPER_CTRL, g, togglegroup,"
      "SUPER_CTRL, w, changegroupactive, f"
      "SUPER_CTRL, e, moveoutofgroup,"
      "SUPER_CTRL, left, moveintogroup, l"
      "SUPER_CTRL, right, moveintogroup, r"
      "SUPER_CTRL, up, moveintogroup, u"
      "SUPER_CTRL, down, moveintogroup, d"
      "SUPER_CTRL, h, moveintogroup, l"
      "SUPER_CTRL, l, moveintogroup, r"
      "SUPER_CTRL, k, moveintogroup, u"
      "SUPER_CTRL, j, moveintogroup, d"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
      ", XF86Calculator, exec, alacritty  -t popup -e calc"
    ]
    ++ switch_workspace
    ++ move_workspace
    ++ eww_trigger_ws;

    bindm = [ "SUPER, mouse:272, movewindow" ];

    binde = [
      ", XF86AudioRaiseVolume, exec,
        wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+"
      ", XF86AudioLowerVolume, exec,
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
    ];
  };
}
