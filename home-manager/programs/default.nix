{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./bash
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./ssh.nix
    ./vscode.nix
  ];
  programs = {
    home-manager.enable = true;

    neovim.baseConfiguration.enable = true;

    direnv.enable = true;
  };
}
