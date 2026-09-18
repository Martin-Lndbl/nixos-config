{ pkgs, ... }:
{
  # spotifywm wraps the real spotify and ships its own desktop entry, complete
  # with icon, StartupWMClass and the spotify: URI handler.
  home.packages = with pkgs; [
    feishin
    spotifywm
  ];
}
