{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/system".source = pkgs.writeScript "system" ''
    #!/bin/sh

    if [ "$1" = "--host" ]; then
      hostname
    elif [ "$1" = "--user" ]; then
      echo "$USER"
    elif [ "$1" = "--uptime" ]; then
      uptime \
        | awk -F'up |,' '{print $2}' \
        | awk '{
          gsub(":"," ")
          if (NF > 2)
            printf "{\"big\":\"%s %s\",\"small\":\"%s hours\"}\n", $1, $2, $3;
          else
            printf "{\"big\":\"%s hours\",\"small\":\"%s minutes\"}\n", $1, $2;
        }'
    else
      exit 1
    fi
  '';
}
