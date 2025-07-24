{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
  # example = pkgs.callPackage ./example { };
  ape = pkgs.callPackage ./ApE { };
  atlauncher = pkgs.callPackage ./atlaucher { };
  hyprctl-rotate = pkgs.callPackage ./hyprctl-rotate.nix { };
  hm = pkgs.home-manager;
  trilium-next-desktop = pkgs.callPackage ./trilium/trilium-next-desktop.nix { };
}
