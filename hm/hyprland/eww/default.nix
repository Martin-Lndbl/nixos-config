{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".source = pkgs.writeText "eww.yuck"
    "${builtins.readFile ./bar/eww.yuck}";

  xdg.configFile."eww/eww.scss".source = import ./bar/eww.scss.nix {
    inherit pkgs config;
  };

  xdg.configFile."eww/scripts" = {
    source = ./bar/scripts;
    recursive = true;
  };
}
