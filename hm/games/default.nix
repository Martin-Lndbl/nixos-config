{ pkgs, ... }:
{
  imports = [
    ./rocketleague.nix
  ];

  home.packages = with pkgs; [
    vitetris
    prismlauncher

    gamemode
    legendary-gl
  ];
}
