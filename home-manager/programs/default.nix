{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./bash
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./ssh.nix
    ./neovim.nix
    # ./vscode.nix
  ];
  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
