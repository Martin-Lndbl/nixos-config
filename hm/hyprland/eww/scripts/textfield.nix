{ pkgs, config, ... }:
{
  xdg.configFile."eww/scripts/textfield".source = pkgs.writeScript "textfield" ''
    #! /bin/sh

    KEY=$(cat ${config.sops.secrets.apininja.path})

    TEXTS=$(curl --silent --fail --get \
      --data-urlencode "X-Api-Key=$KEY" \
      https://api.api-ninjas.com/v1/"$1")

    echo "$TEXTS" | jq '.[0]' | sed '2s/.\{95\} /&\\n/g'
  '';
}
