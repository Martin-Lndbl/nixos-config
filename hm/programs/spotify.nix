{ pkgs, ... }:
{
  home.packages = with pkgs; [
    feishin
    spotifywm
  ];

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Spotify";
    exec = "spotify";
    terminal = false;
    categories = [
      "Application"
      "Network"
      "Audio"
    ];
  };
}
