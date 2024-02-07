/*
  Vectors and icons by <a href="https://www.figma.com/@thewolfkit?ref=svgrepo.com" target="_blank">Thewolfkit</a> in CC Attribution License via <a href="https://www.svgrepo.com/" target="_blank">SVG Repo</a>
*/

{ pkgs, config, ... }:

let
  chcol = color: svg: pkgs.runCommand "chcol" { }
    "sed 's/#ffffff/#${color}/g' ${svg} > $out";
in

with config.colorscheme.palette; {
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

    "eww/images/net_wired.svg".source = chcol base06 ./net_wired.svg;
    "eww/images/net_wifi.svg".source = chcol base06 ./net_wifi.svg;
    "eww/images/net_none.svg".source = chcol base06 ./net_none.svg;

    "eww/images/speaker2.svg".source = chcol base06 ./speaker2.svg;
    "eww/images/speaker1.svg".source = chcol base06 ./speaker1.svg;
    "eww/images/speaker0.svg".source = chcol base06 ./speaker0.svg;
    "eww/images/speakerx.svg".source = chcol base06 ./speakerx.svg;

    "eww/images/mic.svg".source = chcol base06 ./mic.svg;
    "eww/images/micx.svg".source = chcol base06 ./micx.svg;

    "eww/images/bat0.svg".source = chcol base08 ./bat0.svg;
    "eww/images/bat1.svg".source = chcol base06 ./bat1.svg;
    "eww/images/bat2.svg".source = chcol base06 ./bat2.svg;
    "eww/images/bat3.svg".source = chcol base06 ./bat3.svg;
    "eww/images/bat4.svg".source = chcol base06 ./bat4.svg;
    "eww/images/batc.svg".source = chcol base06 ./batc.svg;

    "eww/images/clock.svg".source = chcol base06 ./clock.svg;
    "eww/images/uptime.svg".source = chcol base06 ./uptime.svg;

    "eww/images/sun.svg".source = chcol base06 ./sun.svg;
    "eww/images/star.svg".source = chcol base06 ./star.svg;
    "eww/images/sun_cloud.svg".source = chcol base06 ./sun_cloud.svg;
    "eww/images/moon_cloud.svg".source = chcol base06 ./moon_cloud.svg;
    "eww/images/cloud.svg".source = chcol base06 ./cloud.svg;
    "eww/images/cloud_broken.svg".source = chcol base06 ./cloud_broken.svg;
    "eww/images/rain.svg".source = chcol base06 ./rain.svg;
    "eww/images/thunderstorm.svg".source = chcol base06 ./thunderstorm.svg;
    "eww/images/snow.svg".source = chcol base06 ./snow.svg;
    "eww/images/mist.svg".source = chcol base06 ./mist.svg;

    "eww/images/prev.svg".source = chcol base06 ./prev.svg;
    "eww/images/pause.svg".source = chcol base06 ./pause.svg;
    "eww/images/play.svg".source = chcol base06 ./play.svg;
    "eww/images/next.svg".source = chcol base06 ./next.svg;
    "eww/images/spotify.svg".source = chcol base06 ./spotify.svg;

    "eww/images/github.svg".source = chcol base06 ./github.svg;
    "eww/images/bitbucket.svg".source = ./bitbucket.svg;
    "eww/images/nixos.svg".source = ./nixos.svg;
    "eww/images/outlook.svg".source = ./outlook.svg;
    "eww/images/gmail.svg".source = ./gmail.svg;
    "eww/images/trilium.svg".source = ./trilium.svg;

    "eww/images/shutdown.svg".source = chcol base06 ./shutdown.svg;
    "eww/images/reboot.svg".source = chcol base06 ./reboot.svg;
    "eww/images/lock.svg".source = chcol base06 ./lock.svg;
    "eww/images/sleep.svg".source = chcol base06 ./sleep.svg;
    "eww/images/logout.svg".source = chcol base06 ./logout.svg;
  };
}
