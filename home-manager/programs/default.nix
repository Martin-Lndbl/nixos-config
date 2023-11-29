{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./bash
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./ssh.nix
    ./neovim.nix
    ./cava.nix
    ./spotify.nix
    ./calc.nix
    ./ape.nix
  ];
  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
