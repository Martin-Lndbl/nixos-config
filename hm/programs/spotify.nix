{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    spotifywm
  ];

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Spotify";
    exec = "spotify";
    terminal = false;
    categories = [ "Application" "Network" "Audio" ];
  };
}
