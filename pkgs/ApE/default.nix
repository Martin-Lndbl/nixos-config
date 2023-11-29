{ writeShellScriptBin
, wine-wayland
, fetchzip
}:

let
  pname = "ape";
  version = "current_3.1.3";

  src = fetchzip {
    url = "https://jorgensen.biology.utah.edu/wayned/ape/Download/WIndows/ApE_win_${version}.zip";
    hash = "sha256-by9AUXKnmCtq3MjDQMVdDVnYWkFFm1M1FpIuMi8GlMM=";
  };
in

writeShellScriptBin pname "${wine-wayland}/bin/wine ${src}/ApE.exe"
