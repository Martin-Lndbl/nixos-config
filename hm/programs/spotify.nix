{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    spotifywm
  ];

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Spotify";
    exec = "spotifywm";
    terminal = false;
    categories = [ "Application" "Network" "Audio" ];
  };
}
