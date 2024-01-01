{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".source = pkgs.writeText "eww.yuck"
    ''${builtins.readFile ./variables.yuck}

    (include "${./bar/bar.yuck}")
    (include "${./dashboard/dashboard.yuck}")
  '';

  xdg.configFile."eww/eww.scss".source = 
  with config.colorscheme.colors; pkgs.writeText "eww.scss" 
   ''
    $background: #${base00};
    $foreground: #${base06};

    $active: #${base08};
    $sliders: #${base0D};

    * { all: unset; }

    ${builtins.readFile ./bar/eww.scss}
    ${builtins.readFile ./dashboard/eww.scss}
  '';

  xdg.configFile."eww/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  xdg.configFile."eww/images" = {
    source = ./images;
    recursive = true;
  };
}
