{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/network".source = pkgs.writeScript "network" ''
    #! /bin/sh

    active_network=$(nmcli -t -f NAME,ACTIVE,TYPE connection show | awk -F':' '{if($2=="yes" && $3!="loopback")print$1,$3}')

    NET_CON=$(echo "$active_network" | cut -d' ' -f1)

    $1 update NET_CON="''${NET_CON}"
    type="none"

    if [[ "$active_network" == *"Wired connection"* ]]; then
      type="wired"
    elif [[ "$active_network" == *"wireless"* ]]; then
      type="wifi"
    fi

    echo $type
  '';
}
