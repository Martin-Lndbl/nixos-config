{ pkgs, config, ... }:
{
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "firefox.desktop" "zathura.desktop" ];
    "image/png" = [ "firefox.desktop" ];
    "image/pdf" = [ "firefox.desktop" ];
    "image/webp" = [ "firefox.desktop" ];
    "image/svg+xml" = [ "firefox.desktop" ];
   };
}
