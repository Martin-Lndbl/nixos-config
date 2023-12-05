{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./ape.nix
    ./bash
    ./calc.nix
    ./cava.nix
    ./discord.nix
    ./firefox.nix
    ./git.nix
    ./neovim.nix
    ./spotify.nix
    ./ssh.nix
    ./whatsapp.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
