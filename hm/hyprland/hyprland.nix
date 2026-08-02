{ config, lib, ... }:
# NOTE: package + portalPackage are `null` so the Hyprland binary and portal
# come from the NixOS module (`programs.hyprland.enable`). Mixing versions
# between the NixOS module and this one is unsupported per
# https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos

let
  workspaceBinds = lib.concatMapStrings (ws: ''
    hl.bind("SUPER + ${ws}", hl.dsp.focus({ workspace = "${ws}" }))
    hl.bind("SUPER + SHIFT + ${ws}", hl.dsp.window.move({ workspace = "${ws}" }))
  '') config.workspaces;
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

      window_rule = [
        # Local rules
        {
          match.tag = "code";
          opacity = 0.98;
        }
        {
          match.class = "feishin";
          suppress_event = "maximize";
        }
        # Route startup apps onto their target workspace on spawn.
        # Effect syntax per https://wiki.hypr.land/Configuring/Basics/Window-Rules/#effects
        # `workspace = "<id> silent"` opens the window without switching to it.
        {
          match.class = "thunderbird";
          workspace = "9 silent";
        }
        {
          match.class = "element";
          workspace = "9 silent";
        }
        {
          match.class = "feishin";
          workspace = "9 silent";
        }
        {
          match.class = "Alacritty";
          workspace = "1 silent";
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

    # Anything that needs to be a multi-arg call (hl.bind, hl.on) is written
    # directly as Lua. hl.bind(keys, dispatcher, opts?) — see
    # https://wiki.hypr.land/Configuring/Basics/Binds/
    extraConfig = ''
      -- Startup apps. Placement is handled by workspace-assigning window_rules above.
      hl.on("hyprland.start", function()
        hl.exec_cmd("thunderbird")
        hl.exec_cmd([[element-desktop --password-store="gnome-libsecret"]])
        hl.exec_cmd("feishin")
        hl.exec_cmd("alacritty")
        hl.exec_cmd("alacritty")
      end)

      -- App binds
      hl.bind("SUPER + return", hl.dsp.exec_cmd("alacritty"))
      hl.bind("SUPER + d", hl.dsp.exec_cmd("wofi --show drun"))
      hl.bind("SUPER + g", hl.dsp.exec_cmd("MOZ_ENABLE_WAYLAND=1 firefox"))
      hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
      hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprlock"))
      hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("(hyprlock & systemctl suspend -i)"))

      -- Move focus
      hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
      hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))
      hl.bind("SUPER + h",     hl.dsp.focus({ direction = "left" }))
      hl.bind("SUPER + l",     hl.dsp.focus({ direction = "right" }))
      hl.bind("SUPER + k",     hl.dsp.focus({ direction = "up" }))
      hl.bind("SUPER + j",     hl.dsp.focus({ direction = "down" }))

      -- Move window
      hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
      hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
      hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
      hl.bind("SUPER + SHIFT + h",     hl.dsp.window.move({ direction = "left" }))
      hl.bind("SUPER + SHIFT + l",     hl.dsp.window.move({ direction = "right" }))
      hl.bind("SUPER + SHIFT + k",     hl.dsp.window.move({ direction = "up" }))
      hl.bind("SUPER + SHIFT + j",     hl.dsp.window.move({ direction = "down" }))

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
      hl.bind("SUPER + CTRL + left",  hl.dsp.window.move({ into_group = "left" }))
      hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ into_group = "right" }))
      hl.bind("SUPER + CTRL + up",    hl.dsp.window.move({ into_group = "up" }))
      hl.bind("SUPER + CTRL + down",  hl.dsp.window.move({ into_group = "down" }))
      hl.bind("SUPER + CTRL + h",     hl.dsp.window.move({ into_group = "left" }))
      hl.bind("SUPER + CTRL + l",     hl.dsp.window.move({ into_group = "right" }))
      hl.bind("SUPER + CTRL + k",     hl.dsp.window.move({ into_group = "up" }))
      hl.bind("SUPER + CTRL + j",     hl.dsp.window.move({ into_group = "down" }))

      -- Media / screenshot
      hl.bind("XF86AudioMute",    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"))
      hl.bind("XF86Calculator",   hl.dsp.exec_cmd("alacritty -t popup -e calc"))
      hl.bind("SUPER + SHIFT + s", hl.dsp.exec_cmd("grimblast copy area"))

      -- Mouse
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })

      -- Volume (repeating)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 2%+"), { repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { repeating = true })

      -- Per-workspace switch / move binds
      ${workspaceBinds}
    '';
  };

  # Feed home-manager's session variables into the UWSM-managed Hyprland
  # session so it can find $XDG_CONFIG_HOME (and thus hyprland.lua).
  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
