{ pkgs, ... }:
let
  username = "mrtn";
in
{
  imports = [
    ../../programs/bash.nix
    ../../programs/nvim
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    btop
    mdcat
  ];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";

  xdg.cacheHome = "/scratch/${username}/.cache";
  xdg.stateHome = "/scratch/${username}/.local/share";
}
