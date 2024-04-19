{ pkgs, config, ... }:
{
  xdg.configFile."eww/scripts/textfield".source = pkgs.writeScript "textfield" ''
    #! /bin/sh

    CACHE="$XDG_CACHE_HOME/eww/$1"
    KEY=$(cat ${config.sops.secrets.apininja.path})
    LIMIT=30

    if [ ! -e "$CACHE" ] || [ "$(wc -c < "$CACHE")" -lt 8 ]; then

      # limit can not be set for quotes without API premium access
      if [ "$1" = "jokes" ]; then
        set -- "jokes?limit=$LIMIT"
      fi

      TEXTS=$(curl --silent --fail --get \
        --data-urlencode "X-Api-Key=$KEY" \
        https://api.api-ninjas.com/v1/"$1")

    else
      TEXTS=$(cat "$CACHE")
    fi

    echo "$TEXTS" | jq '.[0]' | sed '2s/.\{95\} /&\\n/g'
    echo "$TEXTS" | jq 'del(.[0])' > "$CACHE"
  '';
}
