{ lib
, makeDesktopItem
, symlinkJoin
, writeShellScriptBin
, gamemode
, jdk
, pname ? "atlauncher"
}:

let
  version = "3.4.35.3";
  src = builtins.fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${version}/ATLauncher-${version}.jar";
    sha256 = "0mk0i5w0mrlcig1i1fgipjn88w46rhbm90b9cvccs141a6nk8kyv";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    inherit icon;
    comment = "Technic Platform Launcher";
    desktopName = "Technic Launcher";
    categories = [ "Game" ];
  };

  icon = builtins.fetchurl {
    # original url = "https://cdn.freebiesupply.com/logos/large/2x/technic-launcher-logo-png-transparent.png";
    url = "https://user-images.githubusercontent.com/36706276/203341849-0b049d7a-8c00-4ff1-b916-1a8aacee7ffb.png";
    sha256 = "0p18sfwaral8f6f5h9r5y9sxrzij2ks9zzyhfmzjldldladrwznq";
  };

  script = writeShellScriptBin pname ''
    ${gamemode}/bin/gamemoderun ${jdk}/bin/java -jar ${src} --working-dir $XDG_DATA_HOME/ATLauncher
  '';
in
symlinkJoin {
  name = "${pname}";
  paths = [ script ];
}
