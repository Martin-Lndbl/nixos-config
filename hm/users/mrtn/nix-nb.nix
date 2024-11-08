{
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    nixWallpaperFromScheme
    ;
in
rec {
  imports = [ ./secrets.nix ];

  appearance.wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    logoScale = 8;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };
  appearance.lockScreen = "${config.xdg.userDirs.pictures}/wallpaper/nix.png";
  appearance.fontSize = 14;
  monitors.center = "eDP-1";
  monitors.left = "DP-1";

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "${monitors.center}, 1920x1080@60, 0x0, 1"
    ];
  };

  programs.bash.shellAliases = {
    cdsem = "cd ~/documents/bsc_info/07_sem/";
  };

  programs.git.userName = "martin_lndbl-NBL";
}
