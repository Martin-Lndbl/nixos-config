{ pkgs, config }:

pkgs.writeText "eww.scss" 
''
  $surface-darkgrey: #20252b;
  $surface-fg: #949494;
  $surface-lightgrey: #3d464e;
  $surface-grey: #2b3238;
  $surface-red: #f87070;

  $background: #1d1f21;
  $foreground: #c5c8c5;

  $sliders: #504C5E;

  $black: #24283B;
  $gray: #565F89;
  $red: #F7768E;
  $green: #73DACA;
  $yellow: #E0AF68;
  $blue: #7AA2F7;
  $magenta: #BB9AF7;
  $cyan: #7DCFFF;

  * { all: unset; }

  tooltip.background {
      background-color: #0f0f17;
      font-size: 18;
      border-radius: 8px;
      color: #bfc9db;
  }

  tooltip label {
      margin: 3px;
  }

  .layout-box {
    // font-family: Phosphor, Koulen;
    padding-right: 15px;
    padding-left: 15px;
    padding-top: 5px;
    padding-bottom: 5px;
    border-radius: 1.5rem;
    color: rgba($foreground, 1);
    background-color: rgba($background, 1)
  }

  .bat-box {
    padding-right: 0.5em;
  }

  .bat-sym {
    font-size: 1.5em;
    padding-right: 2rem;
  }

  .home-sym {
    padding-left: .2em;
    font-size: 2em;
  }

  .muted-sym,
  .time,
  .bat-txt {
    font-size: 1.2em;
  }

  .audio-sym,
  .bright-sym {
    margin: 0 .5em 0 0;
    font-size: 1.2em;
  }

  .audio-box,
  .bright-box {
    font-size: 1.2em;
    margin: 0 1.1em 0 0em;
  }

  .ws-box {
    padding-left: 1.5rem;
  }

  .workspace {
    padding: 10px 10px;
    border: none;
    opacity: .3;
  }

  .ws_exists {
    opacity: 1;
  }

  .ws_active {
    font-size: 1.1em;
    color: $red;
    opacity: 1;
  }

  .audio_slide trough highlight,
  .bright_slide trough highlight {
    background-color: $sliders;
    border-radius: 5px;
  }

  .audio_slide {
    margin-left: .4em;
  }

  scale trough {
    background-color: $foreground;
    border-radius: 5px;
    min-height: 1em;
    min-width: 5em;
    margin-left: .5em;
  }
''