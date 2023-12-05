{ pkgs, config, ... }:
{
  xdg.desktopEntries.whatsapp = {
    name = "Whatsapp";
    genericName = "Messager App";
    exec = "firefox --new-window https://web.whatsapp.com/";
    terminal = false;
    categories = [ "Application" "Network" "Audio" "Video" "InstantMessaging" ];
    mimeType = [ "x-scheme-handler/whatsapp" ];
    type = "Application";
    settings.StartupWMClass = "whatsapp";
  };
}
