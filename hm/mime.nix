{ pkgs, config, ... }:
{
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "firefox.desktop" "zathura.desktop" ];
    "image/png" = [ "firefox.desktop" ];
    "image/pdf" = [ "firefox.desktop" ];
    "image/webp" = [ "firefox.desktop" ];
    "image/svg+xml" = [ "firefox.desktop" ];
    "text/css" = [ "neovim.desktop" ];
    "text/html" = [ "neovim.desktop" ];
    "text/javascript" = [ "neovim.desktop" ];
    "text/markdown" = [ "neovim.desktop" ];
    "text/mathml" = [ "neovim.desktop" ];
    "text/plain" = [ "neovim.desktop" ];
    "text/x-asm" = [ "neovim.desktop" ];
    "text/x-c" = [ "neovim.desktop" ];
    "text/x-java-source" = [ "neovim.desktop" ];
    "text/x-markdown" = [ "neovim.desktop" ];
    "text/x-pascal" = [ "neovim.desktop" ];
    "text/x-python" = [ "neovim.desktop" ];
    "text/x-setext" = [ "neovim.desktop" ];
  };
}
