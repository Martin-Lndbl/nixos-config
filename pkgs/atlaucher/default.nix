{ lib
, fetchurl
, jre
, jre8
, stdenv
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, udev
, xorg
}:

let
  java-version = jre8;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.35.3";

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-2080rVGBBM3YZmmBVBfMhnCErLzxuRDDi4zmCniJYFY=";
  };

  env.ICON = fetchurl {
    url = "https://atlauncher.com/assets/images/logo.svg";
    hash = "sha256-XoqpsgLmkpa2SdjZvPkgg6BUJulIBIeu6mBsJJCixfo=";
  };


  dontUnpack = true;

  buildInputs = [ ];
  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp $src $out/share/java/ATLauncher.jar

    makeWrapper ${java-version}/bin/java $out/bin/${finalAttrs.pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libXxf86vm udev ]}" \
      --add-flags "-jar $out/share/java/ATLauncher.jar" \
      --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
      --add-flags "--no-launcher-update"

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $ICON $out/share/icons/hicolor/scalable/apps/${finalAttrs.pname}.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      desktopName = "ATLauncher";
      categories = [ "Game" ];
    })
  ];
})
