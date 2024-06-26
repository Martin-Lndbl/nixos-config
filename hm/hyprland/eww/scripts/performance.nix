{ pkgs, ... }:
{
  xdg.configFile."eww/scripts/performance".source = pkgs.writeScript "performance" ''
    #!/bin/sh

    ## Files and Data
    PREV_TOTAL=0
    PREV_IDLE=0
    PERFORMANCE_FILE="$XDG_CACHE_HOME/eww/performance"

    if [[ "$1" == "--cpu" ]]; then
      if [[ -f "''${PERFORMANCE_FILE}" ]]; then
        fileCont=$(cat "''${PERFORMANCE_FILE}")
        PREV_TOTAL=$(echo "''${fileCont}" | head -n 1)
        PREV_IDLE=$(echo "''${fileCont}" | tail -n 1)
      fi

      CPU=(`cat /proc/stat | grep '^cpu '`)
      unset CPU[0]
      IDLE=''${CPU[4]}

      TOTAL=0

      for VALUE in "''${CPU[@]:0:4}"; do
        let "TOTAL=$TOTAL+$VALUE"
      done

      if [[ "''${PREV_TOTAL}" != "" ]] && [[ "''${PREV_IDLE}" != "" ]]; then
        # Calculate the CPU usage since we last checked.
        let "DIFF_IDLE=$IDLE-$PREV_IDLE"
        let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
        let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
        echo "''${DIFF_USAGE}"
      else
        echo "?"
      fi

      echo "''${TOTAL}" > "''${PERFORMANCE_FILE}"
      echo "''${IDLE}" >> "''${PERFORMANCE_FILE}"

    elif [[ "$1" == "--mem" ]]; then
      free -m | awk 'NR==2{print "{\"total\": " $2 ", \"used\": " $3 "}"}'
    elif [[ "$1" == "--disk" ]]; then
      df -h / | awk 'NR>1 {gsub(/G/, ""); print "{\"size\":" $2 ",\"used\":" $3 ",\"avail\":" $4 "}"}'
    fi
  '';
}
