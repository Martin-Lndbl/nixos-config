{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/audio".source = pkgs.writeScript "audio" ''
    #! /bin/sh

    set_sink(){
      wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ "$1"%
    }

    get_sink(){
      wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
        awk '{
          if (match($0, /Volume: ([0-9.]+)( \[([A-Z]+)\])?/, arr)) {
            printf "{\"VOL\":\"%s\", \"MUTE\":\"%s\"}\n", arr[1]*100, arr[3]
          }
        }'

    }

    toggle_sink(){
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    }

    set_source(){ # THIS ONLY WORKS IF ALSA IS ALSO ACTIVE
      amixer set Capture,0 "$1"% > /dev/null
    }

    get_source(){
      wpctl status | awk '
        /Sources:/ { flag = 1 }
        /Source endpoints/ { exit }
        flag && /  \*   / {
            if (match($0, /\[vol: ([0-9.]+).?([A-Z]+)?\]/, arr)) {
                printf "{\"VOL\":\"%s\", \"MUTE\":\"%s\"}\n", arr[1]*100, arr[2]
            }
        }'
    }

    toggle_mute(){
      wpctl set-mute @DEFAULT_SOURCE@ toggle
    }

    if [ "$1" == "--set-sink" ]; then
      set_sink "$2"
      echo "$2"
    elif [ "$1" == "--get-sink" ]; then
      get_sink
    elif [ "$1" == "--toggle-sink" ]; then
      toggle_sink
      get_sink
    elif [ "$1" == "--set-source" ]; then
      set_source "$2"
      echo "$2"
    elif [ "$1" == "--get-source" ]; then
      get_source
    elif [ "$1" == "--toggle-source" ]; then
      toggle_mute
      get_source
    fi
  '';
}
