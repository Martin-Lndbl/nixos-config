{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
  hyprctl-rotate = pkgs.callPackage ./hyprctl-rotate.nix { };
}
