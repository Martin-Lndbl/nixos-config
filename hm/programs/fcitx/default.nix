{ pkgs, config, ... }:

{
  xdg.configFile."fcitx5/config".source = ./config;
  xdg.configFile."fcitx5/profile".source = ./profile;
}