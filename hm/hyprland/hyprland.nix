{ config, lib, ... }:
# NOTE: package + portalPackage are `null` so the Hyprland binary and portal
# come from the NixOS module (`programs.hyprland.enable`). Mixing versions
# between the NixOS module and this one is unsupported per
# https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos

let
  inline = lib.generators.mkLuaInline;

  exec = cmd: inline "hl.dsp.exec_cmd(${builtins.toJSON cmd})";
  focusDir = dir: inline "hl.dsp.focus({ direction = ${builtins.toJSON dir} })";
  moveDir = dir: inline "hl.dsp.window.move({ direction = ${builtins.toJSON dir} })";
  intoGroup = dir: inline "hl.dsp.window.move({ into_group = ${builtins.toJSON dir} })";

  switch_workspace = map (ws: {
    _args = [
      "SUPER + ${ws}"
      (inline "hl.dsp.focus({ workspace = ${builtins.toJSON ws} })")
    ];
  }) config.workspaces;

  move_workspace = map (ws: {
    _args = [
      "SUPER + SHIFT + ${ws}"
      (inline "hl.dsp.window.move({ workspace = ${builtins.toJSON ws} })")
    ];
  }) config.workspaces;

in
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.configType = "lua";
  wayland.windowManager.hyprland.package = null;
  wayland.windowManager.hyprland.portalPackage = null;

  # Feed home-manager's session variables into the UWSM-managed Hyprland
  # session so it can find $XDG_CONFIG_HOME (and thus hyprland.lua).
  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland.settings = {
    config = {
      input.follow_mouse = 1;

      general = {
        gaps_in = 5;
        gaps_out = 10;
        resize_on_border = true;
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
      };

      animations.enabled = true;

      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      ecosystem.no_update_news = true;
    };

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 7;
        bezier = "default";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 6;
        bezier = "default";
      }
    ];

    on = {
      _args = [
        "hyprland.start"
        (inline ''
          function()
            hl.exec_cmd("thunderbird")
            hl.exec_cmd([[element-desktop --password-store="gnome-libsecret"]])
            hl.exec_cmd("feishin")
            hl.exec_cmd("alacritty")
            hl.exec_cmd("alacritty")
          end
        '')
      ];
    };

    window_rule = [
      {
        match.tag = "code";
        opacity = 0.98;
      }
      {
        match.class = "feishin";
        suppress_event = "maximize";
      }
      # Route the startup apps onto their target workspaces silently.
      {
        match.class = "thunderbird";
        workspace = "silent 9";
      }
      {
        match.class = "Element";
        workspace = "silent 9";
      }
      {
        match.class = "feishin";
        workspace = "silent 9";
      }
      {
        match.class = "Alacritty";
        workspace = "silent 1";
      }
    ];

    workspace_rule = [
      {
        workspace = "1";
        monitor = config.monitors.center;
      }
      {
        workspace = "2";
        monitor = config.monitors.center;
      }
      {
        workspace = "3";
        monitor = config.monitors.center;
      }
      {
        workspace = "8";
        monitor = config.monitors.right;
      }
      {
        workspace = "9";
        monitor = config.monitors.right;
      }
    ];

    bind = [
      # App binds
      {
        _args = [
          "SUPER + return"
          (exec "alacritty")
        ];
      }
      {
        _args = [
          "SUPER + d"
          (exec "wofi --show drun")
        ];
      }
      {
        _args = [
          "SUPER + g"
          (exec "MOZ_ENABLE_WAYLAND=1 firefox")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + Q"
          (inline "hl.dsp.window.close()")
        ];
      }
      {
        _args = [
          "SUPER + ALT + L"
          (exec "hyprlock")
        ];
      }
      {
        _args = [
          "SUPER + ALT + S"
          (exec "(hyprlock & systemctl suspend -i)")
        ];
      }

      # Move focus
      {
        _args = [
          "SUPER + left"
          (focusDir "left")
        ];
      }
      {
        _args = [
          "SUPER + right"
          (focusDir "right")
        ];
      }
      {
        _args = [
          "SUPER + up"
          (focusDir "up")
        ];
      }
      {
        _args = [
          "SUPER + down"
          (focusDir "down")
        ];
      }
      {
        _args = [
          "SUPER + h"
          (focusDir "left")
        ];
      }
      {
        _args = [
          "SUPER + l"
          (focusDir "right")
        ];
      }
      {
        _args = [
          "SUPER + k"
          (focusDir "up")
        ];
      }
      {
        _args = [
          "SUPER + j"
          (focusDir "down")
        ];
      }

      # Move window
      {
        _args = [
          "SUPER + SHIFT + left"
          (moveDir "left")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + right"
          (moveDir "right")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + up"
          (moveDir "up")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + down"
          (moveDir "down")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + h"
          (moveDir "left")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + l"
          (moveDir "right")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + k"
          (moveDir "up")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + j"
          (moveDir "down")
        ];
      }

      # Layout / floating / fullscreen
      {
        _args = [
          "SUPER + q"
          (inline ''hl.dsp.layout("togglesplit")'')
        ];
      }
      {
        _args = [
          "SUPER + v"
          (inline ''
            function()
              hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
              hl.dispatch(hl.dsp.window.center())
            end
          '')
        ];
      }
      {
        _args = [
          "SUPER + f"
          (inline ''hl.dsp.window.fullscreen({ action = "toggle" })'')
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + f"
          (inline "hl.dsp.window.fullscreen_state({ internal = -1, client = 2 })")
        ];
      }

      # Groups
      {
        _args = [
          "SUPER + CTRL + g"
          (inline "hl.dsp.group.toggle()")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + w"
          (inline "hl.dsp.group.next()")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + e"
          (inline "hl.dsp.window.move({ out_of_group = true })")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + left"
          (intoGroup "left")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + right"
          (intoGroup "right")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + up"
          (intoGroup "up")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + down"
          (intoGroup "down")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + h"
          (intoGroup "left")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + l"
          (intoGroup "right")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + k"
          (intoGroup "up")
        ];
      }
      {
        _args = [
          "SUPER + CTRL + j"
          (intoGroup "down")
        ];
      }

      # Media / screenshot
      {
        _args = [
          "XF86AudioMute"
          (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        ];
      }
      {
        _args = [
          "XF86AudioMicMute"
          (exec "wpctl set-mute @DEFAULT_SOURCE@ toggle")
        ];
      }
      {
        _args = [
          "XF86Calculator"
          (exec "alacritty -t popup -e calc")
        ];
      }
      {
        _args = [
          "SUPER + SHIFT + s"
          (exec "grimblast copy area")
        ];
      }

      # Mouse
      {
        _args = [
          "SUPER + mouse:272"
          (inline "hl.dsp.window.drag()")
          { mouse = true; }
        ];
      }

      # Volume (repeating)
      {
        _args = [
          "XF86AudioRaiseVolume"
          (exec "wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+")
          { repeating = true; }
        ];
      }
      {
        _args = [
          "XF86AudioLowerVolume"
          (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-")
          { repeating = true; }
        ];
      }
    ]
    ++ switch_workspace
    ++ move_workspace;
  };
}
