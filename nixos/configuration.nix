{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./base.nix
    ./machines/nix-nb.nix
    ./display-manager/hyprland.nix
  ];
}
