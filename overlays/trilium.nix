self: super: {
  trilium-desktop = super.trilium-desktop.overrideAttrs
    (
      _: {
        src = builtins.fetchurl {
          url = "https://github.com/zadam/trilium/releases/download/v0.63.5/trilium-linux-x64-0.63.5.tar.xz";
          sha256 = "sha256:1a2h96gd04mqn6cskjhj657dx9wqvlqsvgydjbaqpwc8593swpb3";
        };
      }
    );
}
