{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./bash
    ./calc.nix
    ./cava.nix
    ./discord.nix
    ./fcitx5
    ./firefox.nix
    ./git.nix
    ./mime.nix
    ./nvim
    ./spotify.nix
    ./ssh.nix
    ./vscode.nix
    ./whatsapp.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
