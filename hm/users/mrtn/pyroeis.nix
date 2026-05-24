{ pkgs, ... }:
let
  username = "mrtn";
in
{
  imports = [
    ../../common.nix
    ../../programs/bash.nix
    ../../programs/nvim
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.sessionVariables.TERM = "xterm";

  home.packages = with pkgs; [
    btop
    mdcat
  ];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
}
