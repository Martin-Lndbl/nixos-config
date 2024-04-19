{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/workspaces".source = pkgs.writeScript "workspaces" ''
    #! /bin/sh

    if [ $# -gt 0 ]
      then
      eww update ws_active=$1
    fi

    ws=$(hyprctl workspaces | grep -oP 'workspace ID \K\d+(?= \(\d+\) on monitor)')

    for key in 1 2 3 4 5 6 7 8 9
    do
      if grep -q "$key" <<< "$ws"; then
        eww update ws_''${key}=true
      else
        eww update ws_''${key}=false
      fi
    done
  '';

}
