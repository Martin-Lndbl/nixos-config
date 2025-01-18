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
  imports = [ ./images ] ++ (import ./scripts);

  home.packages = with pkgs; [
    eww
    jq # Used in weather script
  ];

  xdg.configFile."eww/eww.yuck".source = pkgs.writeText "eww.yuck"
    ''${builtins.readFile ./variables.yuck}

    (include "${./bar/bar.yuck}")
    (defwindow bar
      :exclusive true
      :monitor ${builtins.toString config.monitors.primary_id}
      :windowtype "dock"
      :focusable false
      :stacking "fg"
      :geometry (geometry :x "0%"
                          :y "0.5%"
                          :width "99.5%"
                          :height "2%"
                          :anchor "bottom center")
      (barmenu_layout)
    )

    (include "${./dashboard/dashboard.yuck}")
    (defwindow dashboard
      :monitor ${builtins.toString config.monitors.primary_id}
      :stacking "overlay"
      :geometry ( geometry
        :x "0%"
        :y "0%"
        :width "1152px"
        :height "594px"
        :anchor "center"
        )
        (layout)
    )
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

  programs.bash.shellAliases = {
    switch = "home-manager switch --flake ~/.config/nixos-config#mrtn@$(hostname); $XDG_CONFIG_HOME/eww/scripts/workspaces";
  };

  wayland.windowManager.hyprland = {
    settings = with config.colorScheme; {
      exec-once = [
        "eww open bar"
      ];

      bind = [
        "SUPER, escape, exec, $XDG_CONFIG_HOME/eww/scripts/dashboard eww"
      ] ++ eww_trigger_ws;
    };
  };
}
