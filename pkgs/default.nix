{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  ape = pkgs.callPackage ./ApE { };
}
