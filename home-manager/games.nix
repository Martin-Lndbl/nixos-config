{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    atlauncher
  ];
}
