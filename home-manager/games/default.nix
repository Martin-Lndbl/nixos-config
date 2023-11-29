{ pkgs, ... }:
{
  imports = [
    ./atlauncher.nix
  ];

  home.packages = with pkgs; [
    vitetris
  ];
}
