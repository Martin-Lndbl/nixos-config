{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
  # example = pkgs.callPackage ./example { };
  ape = pkgs.callPackage ./ApE { };
  atlauncher = pkgs.callPackage ./atlaucher { };
  hyprctl-rotate = pkgs.callPackage ./hyprctl-rotate.nix { };
  hm = pkgs.home-manager;
  trilium-desktop-pkg = pkgs.callPackage ./trilium/trilium-desktop.nix { };
}
