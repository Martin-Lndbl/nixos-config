{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/dashboard".source = pkgs.writeScript "dashboard" ''
    #! /bin/sh

    $1 active-windows | if grep -q 'dashboard'; then $1 close dashboard; else $1 open dashboard; fi
  '';
}
