{ pkgs, config, ... }:
{
  xdg.configFile."eww/scripts/weather".source = pkgs.writeScript "weather" ''
    #!/bin/sh

    KYOTO="1857910"
    GARMISCH="2922530"

    KEY=$(cat ${config.sops.secrets.openweathermap.path})
    ID=$GARMISCH
    UNIT="metric"

    read -d '\n' weather_mapping << EndOfText
    {
      "01d": {
        "icon": "sun",
        "wq1": "It's a sunny day, gonna be fun!",
        "wq2": "Don't go wandering all by yourself though...",
        "hex": "#ffd86b"
      },
      "01n": {
        "icon": "star",
        "wq1": "It's a clear night.",
        "wq2": "You might want to take a evening stroll to relax...",
        "hex": "#fcdcf6"
      },
      "02d": {
        "icon": "sun_cloud",
        "wq1": "It's  cloudy, sort of gloomy.",
        "wq2": "You'd better get a book to read...",
        "hex": "#adadff"
      },
      "02n": {
        "icon": "moon_cloud",
        "wq1": "It's a cloudy night.",
        "wq2": "How about some hot chocolate and a warm bed?",
        "hex": "#adadff"
      },
      "03d": {
        "icon": "cloud",
        "wq1": "It's  cloudy, sort of gloomy.",
        "wq2": "You'd better get a book to read...",
        "hex": "#adadff"
      },
      "03n": {
        "icon": "cloud",
        "wq1": "It's a cloudy night.",
        "wq2": "How about some hot chocolate and a warm bed?",
        "hex": "#adadff"
      },
      "04d": {
        "icon": "cloud_broken",
        "wq1": "It's  cloudy, sort of gloomy.",
        "wq2": "You'd better get a book to read...",
        "hex": "#adadff"
      },
      "04n": {
        "icon": "cloud_broken",
        "wq1": "It's a cloudy night.",
        "wq2": "How about some hot chocolate and a warm bed?",
        "hex": "#adadff"
      },
      "09d": {
        "icon": "rain",
        "wq1": "It's rainy, it's a great day!",
        "wq2": "Get some ramen and watch as the rain falls...",
        "hex": "#6b95ff"
      },
      "09n": {
        "icon": "rain",
        "wq1": "It's gonna rain tonight it seems.",
        "wq2": "Make sure your clothes aren't still outside...",
        "hex": "#6b95ff"
      },
      "10d": {
        "icon": "rain",
        "wq1": "It's rainy, it's a great day!",
        "wq2": "Get some ramen and watch as the rain falls...",
        "hex": "#6b95ff"
      },
      "10n": {
        "icon": "rain",
        "wq1": "It's gonna rain tonight it seems.",
        "wq2": "Make sure your clothes aren't still outside...",
        "hex": "#6b95ff"
      },
      "11d": {
        "icon": "thunderstorm",
        "wq1": "There's storm for forecast today.",
        "wq2": "Make sure you don't get blown away...",
        "hex": "#ffeb57"
      },
      "11n": {
        "icon": "thunderstorm",
        "wq1": "There's gonna be storms tonight.",
        "wq2": "Make sure you're warm in bed and the windows are shut...",
        "hex": "#ffeb57"
      },
      "13d": {
        "icon": "snow",
        "wq1": "It's gonna snow today.",
        "wq2": "You'd better wear thick clothes and make a snowman as well!",
        "hex": "#e3e6fc"
      },
      "13n": {
        "icon": "snow",
        "wq1": "It's gonna snow tonight.",
        "wq2": "Make sure you get up early tomorrow to see the sights...",
        "hex": "#e3e6fc"
      },
      "50d": {
        "icon": "mist",
        "wq1": "Forecast says it's misty.",
        "wq2": "Make sure you don't get lost on your way...",
        "hex": "#84afdb"
      },
      "50n": {
        "icon": "mist",
        "wq1": "Forecast says it's a misty night.",
        "wq2": "Don't go anywhere tonight or you might get lost...",
        "hex": "#84afdb"
      }
    }
    EndOfText

    weather=`curl -sf -G \
        --data-urlencode "APPID=$KEY" \
        --data-urlencode "id=$ID" \
        --data-urlencode "units=$UNIT" \
        "http://api.openweathermap.org/data/2.5/weather"`

    if [ ! -z "$weather" ]; then

      echo "$weather" | jq \
        --arg icon "$icon" \
        --argjson weather_mapping "$weather_mapping" \
        '{
          city: .name,
          country: .sys.country,
          desc: .weather[0].description,
          temp: .main.temp,
          feels: .main.feels_like
        } + $weather_mapping[.weather[0].icon]'

    else

      jq -n '{
        city: "The Void",
        country: "None",
        desc: "Unknown",
        temp: "-",
        feels: "-",
        icon: "?",
        wq1: "Ah well, no weather huh?",
        wq2: "Even if there'\${"''"}s no weather, it'\${"''"}s gonna be a great day!",
        hex: "#000000"
      }'

    fi
  '';
}

