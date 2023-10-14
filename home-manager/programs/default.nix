{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./bash
    ./eww
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./ssh.nix
    ./vscode.nix
  ];
  programs = {
    home-manager.enable = true;

    neovim.baseConfiguration.enable = true;
    neovim.baseConfiguration.colorscheme = "spacecamp_transparent";

    direnv.enable = true;
  };
}
