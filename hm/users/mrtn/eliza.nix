# Create the following symbolic links before first switching into this generation
# ln -s /scratch ~/scratch
# ln -s /scratch/mrtn/.local ~/.local

{ pkgs, ... }:
let
  username = "mrtn";
in
{
  imports = [
    ../../programs/bash.nix
    ../../programs/nvim
    ../../common.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.sessionVariables.TERM = "xterm";

  home.packages = with pkgs; [
    btop
    mdcat
    claude-code
  ];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";


  xdg = {
    enable = true;
    userDirs.enable = false;
    userDirs.createDirectories = false;
    cacheHome = "/scratch/${username}/.cache";
    stateHome = "/scratch/${username}/.local/state";
    dataHome = "/scratch/${username}/.local/share";
  };
}
