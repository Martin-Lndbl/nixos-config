{ pkgs, lib, config, ... }:

{

  imports = [ ./images ];

  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".source = pkgs.writeText "eww.yuck"
    ''${builtins.readFile ./variables.yuck}

    (include "${./bar/bar.yuck}")
    (include "${./dashboard/dashboard.yuck}")
  '';

  xdg.configFile."eww/eww.scss".source =
    with config.colorscheme.colors; with builtins; pkgs.writeText "eww.scss"
      ''
        $background: #${base00};
        $foreground: #${base05};

        $active: #${base08};
        $sliders: #${base0C};

        ${lib.attrsets.foldlAttrs
          (acc: n: v: acc + "\n\$${n}: #${v};") "" config.colorscheme.colors}

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
}
