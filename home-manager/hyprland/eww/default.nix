{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".source = pkgs.writeText "eww.yuck"
    "${builtins.readFile ./config_dir/eww.yuck}";

  xdg.configFile."eww/eww.scss".source = import ./config_dir/eww.scss.nix {
    inherit pkgs config;
  };

  xdg. configFile."eww/scripts" = {
    source = ./config_dir/scripts;
    recursive = true;
  };
}
