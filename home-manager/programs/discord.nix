{ pkgs, config, ... }:
{
  xdg.desktopEntries.discord = {
    name = "Discord";
    genericName = "All-in-one cross-platform voice and text chat for gamers";
    exec = "firefox --new-window https://discord.com/app";
    terminal = false;
    categories = [ "Application" "Network" "Audio" "Video" "InstantMessaging" ];
    mimeType = [ "x-scheme-handler/discord" ];
    type = "Application";
    settings.StartupWMClass = "discord";
  };
}
