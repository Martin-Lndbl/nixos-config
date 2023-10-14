{ pkgs, config, ... }:

let
  configDir = ./config_dir;
in

{
  programs.eww = {
    inherit configDir;
    enable = true;
    package = pkgs.eww-wayland;
  };
}
