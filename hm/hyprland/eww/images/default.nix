/*
  Vectors and icons by <a href="https://www.figma.com/@thewolfkit?ref=svgrepo.com" target="_blank">Thewolfkit</a> in CC Attribution License via <a href="https://www.svgrepo.com/" target="_blank">SVG Repo</a>
*/

{ pkgs, config, ... }:

let
  chcol = color: svg: pkgs.runCommand "chcol" { }
    "sed 's/#ffffff/#${color}/g' ${svg} > $out";
in

with config.colorscheme.colors; {
  xdg.configFile = {

    /*
      Images for buttons should be 256x256
      and if they are subject to colorscheme 
      changes only contain the color #ffffff
    */

    "eww/images/pb.png".source = ./pb.png;

    "eww/images/home.svg".source = chcol base06 ./home.svg;

    "eww/images/brightness.svg".source = chcol base06 ./brightness.svg;
    "eww/images/disk.svg".source = chcol base06 ./disk.svg;

    "eww/images/netw.svg".source = chcol base06 ./netw.svg;
    "eww/images/wifi.svg".source = chcol base06 ./wifi.svg;
    "eww/images/nonet.svg".source = chcol base06 ./nonet.svg;

    "eww/images/speaker2.svg".source = chcol base06 ./speaker2.svg;
    "eww/images/speaker1.svg".source = chcol base06 ./speaker1.svg;
    "eww/images/speaker0.svg".source = chcol base06 ./speaker0.svg;
    "eww/images/speakerx.svg".source = chcol base06 ./speakerx.svg;

    "eww/images/bat0.svg".source = chcol base06 ./bat0.svg;
    "eww/images/bat1.svg".source = chcol base06 ./bat1.svg;
    "eww/images/bat2.svg".source = chcol base06 ./bat2.svg;
    "eww/images/bat3.svg".source = chcol base06 ./bat3.svg;
    "eww/images/bat4.svg".source = chcol base06 ./bat4.svg;
    "eww/images/bat5.svg".source = chcol base06 ./bat5.svg;

    "eww/images/shutdown.svg".source = chcol base08 ./shutdown.svg;
    "eww/images/reboot.svg".source = chcol base0A ./reboot.svg;
    "eww/images/lock.svg".source = chcol base0E ./lock.svg;
    "eww/images/sleep.svg".source = chcol base0B ./sleep.svg;
    "eww/images/logout.svg".source = chcol base0C ./logout.svg;
  };
}
