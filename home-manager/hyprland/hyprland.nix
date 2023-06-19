{ pkgs, config, ... }:

pkgs.writeText "hyprland.conf" ''

# Colors

$white = 0xffffffff
$gray = 0xff444444
$active_blue = 0x9912A3E3
$inactive_blue = 0x99164650

# Startup
exec-once = swaybg -i ${config.appearance.wallpaper}
exec-once = waybar
exec-once = systemctl --user import-environment DISPLAY WAYLAND_DISPLAY

exec-once = [workspace 9; noanim; fakefullscreen] firefox https://outlook.live.com/calendar/0/view/week
exec-once = [workspace 9; noanim] spotifywm
exec-once = [workspace 9; noanim] whatsapp-for-linux

exec-once = [workspace 1; noanim] alacritty
exec-once = [workspace 1; noanim] alacritty
exec-once = [workspace 1; noanim] alacritty

monitor= eDP-1, 1920x1080@60,0x0,1
monitor=,highres,auto,1

general {
	gaps_in = 5
	gaps_out = 10
	col.active_border = $white
	col.inactive_border = $gray
	col.group_border = $inactive_blue
	col.group_border_active = $active_blue
	resize_on_border = true
}

decoration {
    rounding=5
    blur=1
    blur_size=3 # minimum 1
    blur_passes=2 # minimum 1, more passes = more resource intensive.

	drop_shadow = true
	shadow_range = 4
}

animations {
    enabled=1
    animation=windows,1,7,default
    animation=workspaces,1,6,default
}

input {
  kb_layout=de
  follow_mouse=1
}

dwindle {
  pseudotile = true
  force_split = 2
  preserve_split = true
}

master {
	new_is_master = true
}

# App binds

bind=SUPER, return, exec, alacritty
bind=SUPER, d, exec, wofi --show run
bind=SUPER, g, exec, MOZ_ENABLE_WAYLAND=1 firefox
bind=SUPER_SHIFT, Q, killactive
bind=SUPERALT, L, exec, swaylock -fel
bind=SUPERALT, S, exec, swaylock -fel; sleep 1; systemctl suspend -i

# Move focus

bind=SUPER, left, movefocus, l
bind=SUPER, right, movefocus, r
bind=SUPER, up, movefocus, u
bind=SUPER, down, movefocus, d

bind=SUPER, h, movefocus, l
bind=SUPER, l, movefocus, r
bind=SUPER, k, movefocus, u
bind=SUPER, j, movefocus, d

bind=SUPER_SHIFT, left, movewindow, l
bind=SUPER_SHIFT, right, movewindow, r
bind=SUPER_SHIFT, up, movewindow, u
bind=SUPER_SHIFT, down, movewindow, d

bind=SUPER_SHIFT, h, movewindow, l
bind=SUPER_SHIFT, l, movewindow, r
bind=SUPER_SHIFT, k, movewindow, u
bind=SUPER_SHIFT, j, movewindow, d

bind=SUPER, q, togglesplit,
bind=SUPER, v, togglefloating,
bind=SUPER, v, centerwindow,
bind=SUPER, f, fullscreen,
bind=SUPER_SHIFT, f, fakefullscreen

# Groups
bind=SUPER_CTRL, g, togglegroup,
bind=SUPER_CTRL, w, changegroupactive, f
bind=SUPER_CTRL, e, moveoutofgroup,

bind=SUPER_CTRL, left, moveintogroup, l
bind=SUPER_CTRL, right, moveintogroup, r
bind=SUPER_CTRL, up, moveintogroup, u
bind=SUPER_CTRL, down, moveintogroup, d
bind=SUPER_CTRL, h, moveintogroup, l
bind=SUPER_CTRL, l, moveintogroup, r
bind=SUPER_CTRL, k, moveintogroup, u
bind=SUPER_CTRL, j, moveintogroup, d


# Window Rules

windowrulev2 = float, title:^(popup)$
windowrulev2 = rounding 0, xwayland:1, floating:1

# Firefox
#	Popups
windowrulev2 = size 578 187, title:^((?!Save)(?!Mozilla firefox).)*$,floating:1,class:^(firefox)$
#	Downloads 
windowrulev2 = size 800 400, title:^(Save)(.*)$, floating:1

# Color
windowrulev2 = size 488 316, title:^(Choose a color)$, floating:1, class:^(firefox)$

# Whatsapp 
windowrulev2=fakefullscreen,class:^(whatsapp-for-linux)$

# Floats
bind=SUPER, r, submap, resize
submap = resize

binde=, left, resizeactive,-20 0
binde=, right, resizeactive,20 0
binde=, up, resizeactive,0 -20
binde=, down, resizeactive,0 20

binde=, h, resizeactive,-20 0
binde=, l, resizeactive,20 0
binde=, k, resizeactive,0 -20
binde=, j, resizeactive,0 20

binde=SUPER, left, moveactive,-20 0
binde=SUPER, right, moveactive,20 0
binde=SUPER, up, moveactive,0 -20
binde=SUPER, down, moveactive,0 20

binde=SUPER, h, moveactive,-20 0
binde=SUPER, l, moveactive,20 0
binde=SUPER, k, moveactive,0 -20
binde=SUPER, j, moveactive,0 -20

bind=, mouse:272, movewindow # 272 = LMB
bind=, c, centerwindow,

bind=, escape, submap, reset
bind=SUPER, escape, submap, reset
submap = reset

bind=SUPER, c, centerwindow,
bindm=SUPER, mouse:272, movewindow 

# Workspaces

# wsbind = 1, eDP-1
# wsbind = 2, eDP-1
# wsbind = 3, eDP-1
# wsbind = 8, DP-1
# wsbind = 9, DP-1

workspace=1, monitor:${config.monitors.center}, default:true
workspace=2, monitor:${config.monitors.center}
workspace=3, monitor:${config.monitors.center}
workspace=8, monitor:${config.monitors.right}
workspace=9, monitor:${config.monitors.right}, default:true

bind=SUPER, 1, workspace, 1
bind=SUPER, 2, workspace, 2
bind=SUPER, 3, workspace, 3
bind=SUPER, 4, workspace, 4
bind=SUPER, 5, workspace, 5
bind=SUPER, 6, workspace, 6
bind=SUPER, 7, workspace, 7
bind=SUPER, 8, workspace, 8
bind=SUPER, 9, workspace, 9

bind=SUPER_SHIFT, 1, movetoworkspace, 1
bind=SUPER_SHIFT, 2, movetoworkspace, 2
bind=SUPER_SHIFT, 3, movetoworkspace, 3
bind=SUPER_SHIFT, 4, movetoworkspace, 4
bind=SUPER_SHIFT, 5, movetoworkspace, 5
bind=SUPER_SHIFT, 6, movetoworkspace, 5
bind=SUPER_SHIFT, 7, movetoworkspace, 7
bind=SUPER_SHIFT, 8, movetoworkspace, 8
bind=SUPER_SHIFT, 9, movetoworkspace, 9

# workspace = eDP-1, 1
# workspace DP-1, 9
# Audio
bind=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind=, XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle
binde=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+
binde=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-

# Misc
bind=, XF86MonBrightnessUp, exec, alacritty
binde=, XF86MonBrightnessUp, exec, brightnessctl set +2%
binde=, XF86MonBrightnessDown, exec, brightnessctl set 2%- -n 100

bind=, XF86Calculator, exec, alacritty  -t popup -e calc
''
