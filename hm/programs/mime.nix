{ ... }:
{
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [
      "firefox.desktop"
      "zathura.desktop"
    ];
    "image/png" = [ "firefox.desktop" ];
    "image/webp" = [ "firefox.desktop" ];
    "image/svg+xml" = [ "firefox.desktop" ];
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    "x-scheme-handler/file" = [ "org.gnome.Nautilus.desktop" ];
  };
}
