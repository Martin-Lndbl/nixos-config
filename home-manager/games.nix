{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vitetris
    atlauncher # For future fixing attempts: https://discordapp.com/channels/329440410839678986/427569646447624216/1176637021595377744
  ];
}
