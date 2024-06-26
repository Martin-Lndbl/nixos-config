{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/spotify".source = pkgs.writeScript "spotify" ''
    #!/usr/bin/env bash

    SP_VERSION="0.1"
    SP_DEST="org.mpris.MediaPlayer2.spotify"
    SP_PATH="/org/mpris/MediaPlayer2"
    SP_MEMB="org.mpris.MediaPlayer2.Player"
    ART_DIR="$XDG_CACHE_HOME/eww/spotify"

    # SHELL OPTIONS

    shopt -s expand_aliases

    function sp-dbus {
      dbus-send --print-reply --dest=$SP_DEST $SP_PATH $SP_MEMB.$1 ''${*:2} > /dev/null
    }


    function sp-metadata {
      dbus-send \
        --print-reply \
        --dest=$SP_DEST \
        $SP_PATH \
        org.freedesktop.DBus.Properties.GetAll string:"$SP_MEMB" \
        | grep -Ev "^method" \
        | grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)' \
        | sed -E '2~2 a|' \
        | tr -d '\n' \
        | sed -E 's/\|/\n/g' \
        | sed -E 's/(xesam:)|(mpris:)//' \
        | sed -E 's/^"//' \
        | sed -E 's/"$//' \
        | sed -E 's/"+/|/' \
        | sed -E 's/ +/ /g'
    }


    function sp-eval {
      # Prints the currently playing track as shell variables, ready to be eval'ed

      sp-metadata \
        | grep --color=never -E "(title)|(artist)|(artUrl)|(PlaybackStatus)" \
        | sort -r \
        | sed 's/^\([^|]*\)\|/\U\1/' \
        | sed -E 's/\|/="/' \
        | sed -E 's/$/"/' \
        | sed -E 's/^/SPOTIFY_/'
    }

    function sp-art {
      # Prints the artUrl.

      sp-metadata | grep "artUrl" | cut -d'|' -f2
    }


    function sp-current {

      mkdir -p $ART_DIR
      eval $(sp-eval)
      HASH=$(echo $SPOTIFY_ARTURL | sed 's/.*\///')

      if [[ ! -f "$ART_DIR/$HASH.png" ]]; then
        curl -s "$(sp-art)" -o "$ART_DIR/$HASH.png"
      fi

      echo "{
        \"title\":\"$SPOTIFY_TITLE\",
        \"artist\":\"$SPOTIFY_ARTIST\",
        \"status\":\"$SPOTIFY_PLAYBACKSTATUS\",
        \"artUrl\":\"$ART_DIR/$HASH.png\"
      }"
    }


    function sp-help {
      # Prints usage information.

      echo "Usage: sp [command]"
      echo "Control a running Spotify instance from the command line."
      echo ""
      echo "  sp play       - Play/pause Spotify"
      echo "  sp next       - Go to next track"
      echo "  sp prev       - Go to previous track"
      echo ""
      echo "  sp current    - Return currently playing track as json"
      echo "  sp metadata   - Dump the current track's metadata"
      echo "  sp eval       - Return the metadata as a shell script"
      echo "  sp art        - Print the URL to the current track's album artwork"
      echo ""
      echo "  sp help       - Show this information"
    }

    alias sp-play="  sp-dbus PlayPause"
    alias sp-next="  sp-dbus Next"
    alias sp-prev="  sp-dbus Previous"


    SPOTIFY_PID="$(pidof -s spotify || pidof -s .spotify-wrapped)"

    if [[ -z "$SPOTIFY_PID" ]]; then
      echo "{
        \"title\":\"Spotify is unreachable\",
        \"artist\":\"\",
        \"status\":\"Paused\",
        \"artUrl\":\"./images/spotify.svg\"
      }"
      exit 0
    fi

    QUERY_ENVIRON="$(cat /proc/''${SPOTIFY_PID}/environ | tr '\0' '\n' | grep "DBUS_SESSION_BUS_ADDRESS" | cut -d "=" -f 2-)"
    if [[ "''${QUERY_ENVIRON}" != "" ]]; then
      export DBUS_SESSION_BUS_ADDRESS="''${QUERY_ENVIRON}"
    fi

    subcommand="$1"

    if [[ -z "$subcommand" ]]; then
      # No arguments given, print help.
      sp-help
    else
      # Arguments given, check if it's a command.
      if $(type sp-$subcommand > /dev/null 2> /dev/null); then
        # It is. Run it.
        shift
        eval "sp-$subcommand $@"
      fi
    fi
  '';
}
