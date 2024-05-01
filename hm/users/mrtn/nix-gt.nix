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
    uni = "cd /D/docs/uni/06_sem/";
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
    userName = "martin-lndbl-GTL";
    extraConfig.safe.directory = [
      "/D/docs/03_sem"
      "/D/docs/04_sem"
      "/D/docs/uni/ASP/task4-concurrency-Martin-Lndbl"
      "/D/docs/uni/06_sem/parprog/published-assignments"
    ];
  };

}
