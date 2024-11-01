{ inputs, pkgs, lib, config, ... }:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    nixWallpaperFromScheme;
in
{
  imports = [ ./secrets.nix ];

  appearance.wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    logoScale = 8;
    logoColor1 = config.colorscheme.palette.base03;
    logoColor2 = config.colorscheme.palette.base04;
  };

  appearance.fontSize = 18;
  monitors.center = "DP-2";
  monitors.right = "DP-3";

  programs.bash.shellAliases = {
    cdsem = "cd /D/docs/bsc_info/07_sem/";
  };

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
    extraConfig = ''
      STICKY_OTHER_WRITABLE 01;34
      OTHER_WRITABLE 01;34
    '';
  };

  programs.git = {
    userName = "martin_lndbl-GTL";
    extraConfig.safe.directory = [
      "*"
    ];
  };

  wayland.windowManager.hyprland.settings.monitor = [
    ", highres, auto, 1"
  ];
}
