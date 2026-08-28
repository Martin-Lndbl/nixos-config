{ config, lib, ... }:

let
  workspaceBinds = lib.concatMapStrings (ws: ''
    hl.bind("SUPER + ${ws}", hl.dsp.focus({ workspace = "${ws}" }))
    hl.bind("SUPER + SHIFT + ${ws}", hl.dsp.window.move({ workspace = "${ws}" }))
  '') config.workspaces;

  # vim-style keys double up on the arrow keys for every directional bind below
  directions = [
    { key = "left"; dir = "left"; }
    { key = "right"; dir = "right"; }
    { key = "up"; dir = "up"; }
    { key = "down"; dir = "down"; }
    { key = "h"; dir = "left"; }
    { key = "l"; dir = "right"; }
    { key = "k"; dir = "up"; }
    { key = "j"; dir = "down"; }
  ];

  focusBinds = lib.concatMapStrings (d: ''
    hl.bind("SUPER + ${d.key}", hl.dsp.focus({ direction = "${d.dir}" }))
  '') directions;

  moveWindowBinds = lib.concatMapStrings (d: ''
    hl.bind("SUPER + SHIFT + ${d.key}", hl.dsp.window.move({ direction = "${d.dir}" }))
  '') directions;

  moveIntoGroupBinds = lib.concatMapStrings (d: ''
    hl.bind("SUPER + CTRL + ${d.key}", hl.dsp.window.move({ into_group = "${d.dir}" }))
  '') directions;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;

    settings = {
      config = {
        input.follow_mouse = 1;

        general = {
          gaps_in = 5;
          gaps_out = 10;
          resize_on_border = true;
          border_size = 1;
          "col.active_border" = "rgba(6a9fb5ff)";
          "col.inactive_border" = "rgba(00000000)";
        };

        decoration = {
          rounding = 15;
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

      window_rule = [
        {
          match.tag = "code";
          opacity = 0.98;
        }
        {
          match.class = "feishin";
          suppress_event = "maximize";
        }
        {
          match.class = "tablet-buttons";
          float = true;
          pin = true;
          size = "180 140";
          move = "100%-190 100%-260";
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
    };

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("[workspace 9 silent] thunderbird")
        hl.exec_cmd([[[workspace 9 silent] element-desktop --password-store="gnome-libsecret"]])
        hl.exec_cmd("[workspace 9 silent] feishin")
        hl.exec_cmd("[workspace 1 silent] ghostty")
      end)

      -- App binds
      hl.bind("SUPER + return", hl.dsp.exec_cmd("ghostty"))
      hl.bind("SUPER + d", hl.dsp.global("caelestia:launcher"))
      hl.bind("SUPER + n", hl.dsp.global("caelestia:sidebar"))
      hl.bind("SUPER + g", hl.dsp.exec_cmd("MOZ_ENABLE_WAYLAND=1 firefox"))
      hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
      hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("caelestia-shell ipc call lock lock"))
      hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("(caelestia-shell ipc call lock lock & systemctl suspend -i)"))

      -- Move focus
      ${focusBinds}
      -- Move window
      ${moveWindowBinds}

      -- Layout / floating / fullscreen
      hl.bind("SUPER + q", hl.dsp.layout("togglesplit"))
      hl.bind("SUPER + v", function()
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        hl.dispatch(hl.dsp.window.center())
      end)
      hl.bind("SUPER + f", hl.dsp.window.fullscreen({ action = "toggle" }))
      hl.bind("SUPER + SHIFT + f", hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }))

      -- Groups
      hl.bind("SUPER + CTRL + g", hl.dsp.group.toggle())
      hl.bind("SUPER + CTRL + w", hl.dsp.group.next())
      hl.bind("SUPER + CTRL + e", hl.dsp.window.move({ out_of_group = true }))
      ${moveIntoGroupBinds}

      -- Media / screenshot
      hl.bind("XF86AudioMute",    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"))
      hl.bind("XF86Calculator",   hl.dsp.exec_cmd("ghostty --title=popup -e calc"))
      hl.bind("SUPER + SHIFT + s", hl.dsp.exec_cmd("grimblast copy area"))

      -- Mouse
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })

      -- Volume (repeating)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+"), { repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { repeating = true })

      ${workspaceBinds}
    '';
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
