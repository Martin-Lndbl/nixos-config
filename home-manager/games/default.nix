{ pkgs, ... }:
{
  imports = [
  ];

  home.packages = with pkgs; [
    vitetris
    prismlauncher
  ];
}
