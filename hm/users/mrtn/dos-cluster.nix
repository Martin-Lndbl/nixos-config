# Shared setup for the TUM DOS cluster nodes (irene, eliza), where $HOME is
# small and the real storage lives under /scratch.
#
# Create the following symbolic links before first switching into this generation
# ln -s /scratch ~/scratch
# ln -s /scratch/mrtn/.local ~/.local

{ config, pkgs, ... }:
{
  imports = [ ../headless.nix ];

  home.packages = with pkgs; [
    btop
    mdcat
    claude-code
  ];

  xdg = {
    enable = true;
    userDirs.enable = false;
    userDirs.createDirectories = false;
    cacheHome = "/scratch/${config.home.username}/.cache";
    stateHome = "/scratch/${config.home.username}/.local/state";
    dataHome = "/scratch/${config.home.username}/.local/share";
  };
}
