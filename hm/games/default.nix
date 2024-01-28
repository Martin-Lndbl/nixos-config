{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    prismlauncher
  ];
}
