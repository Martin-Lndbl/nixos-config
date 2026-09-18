{ config, lib, ... }:
{
  imports = [
    ../common.nix
    ../programs/bash.nix
    ../programs/nvim
  ];

  # mkDefault so a non-mrtn host (aws) can just set its own.
  home.username = lib.mkDefault "mrtn";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "25.11";

  home.sessionVariables.TERM = "xterm";

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";
}
