{ pkgs, lib, config, ... }:

let
  eww_trigger_ws =
    (builtins.map
      (ws: "SUPER, ${ws}, exec, $XDG_CONFIG_HOME/eww/scripts/workspaces ${ws}")
      config.workspaces) ++
    (builtins.map
      (ws: "SUPER_SHIFT, ${ws}, exec, $XDG_CONFIG_HOME/eww/scripts/workspaces ${ws}")
      config.workspaces
    );

in
{
  imports = [ ./images ];

  home.packages = with pkgs; [
    eww-wayland
    jq # Used in weather script
  ];

  xdg.configFile."eww/eww.yuck".source = pkgs.writeText "eww.yuck"
    ''${builtins.readFile ./variables.yuck}

    (include "${./bar/bar.yuck}")
    (include "${./dashboard/dashboard.yuck}")
  '';

  xdg.configFile."eww/eww.scss".source =
    with config.colorscheme.palette; with builtins; pkgs.writeText "eww.scss"
      ''
        $background: #${base00};
        $foreground: #${base05};

        $active: #${base08};
        $sliders: #${base09};

        $profile: url("${config.appearance.profile.picture}");

        ${lib.attrsets.foldlAttrs
          (acc: n: v: acc + "\n\$${n}: #${v};") "" config.colorscheme.palette}

        * { all: unset; }

        ${substring 43 (-1) (readFile ./bar/eww.scss)
        /*removes import of itself in production*/}
        ${substring 43 (-1) (readFile ./dashboard/eww.scss)
        /*removes import of itself in production*/}
      '';

  xdg.configFile."eww/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  programs.bash.shellAliases = {
    switch = "home-manager switch --flake ~/.config/nixos-config#mrtn@$(hostname); $XDG_CONFIG_HOME/eww/scripts/workspaces";
  };

  # TODO: add hyprland binds to pause/play spotify with <space>
  wayland.windowManager.hyprland = {
    settings = with config.colorScheme; {
      exec-once = [
        "eww open bar"
      ];

      bind = [
        "SUPER, escape, exec, eww open dashboard"
      ] ++ eww_trigger_ws;
    };
    extraConfig = ''
      bind = SUPER, escape, submap, dashboard

      submap = dashboard
      bind = , space, exec, ${./scripts/spotify} play
      bind = SUPER, escape, exec, eww close dashboard
      bind = , escape, exec, eww close dashboard
      bind = , escape, submap, reset
      bind = SUPER, escape, submap, reset
      submap = reset
    '';
  };
}
