{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  ape = pkgs.callPackage ./ApE { };
  atlauncher = pkgs.callPackage ./atlaucher { };
  hyprctl-rotate = pkgs.callPackage ./hyprctl-rotate.nix { };
}
