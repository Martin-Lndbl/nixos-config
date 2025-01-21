{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./secrets.nix
    ../../programs/bash.nix
    ../../programs/nvim
  ];

  home.username = "martinLi";
  home.homeDirectory = "/home/martinLi";

  home.packages = with pkgs; [
    mdcat
    clipboard-jh
  ];

  home.sessionVariables = {
    TERM = "xterm";
  };

  colorScheme = inputs.nix-colors.colorSchemes.classic-dark;

  programs.git.userName = "martinLi-irene";
  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  xdg.enable = true;
  xdg.cacheHome = "/scratch/${config.home.username}/.cache";
  xdg.stateHome = "/scratch/${config.home.username}/.local/share";
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    desktop = "${config.home.homeDirectory}/.local/share/applications";
    pictures = "${config.home.homeDirectory}/other/pictures";
    music = "${config.home.homeDirectory}/other/music";
    videos = "${config.home.homeDirectory}/other/videos";
    templates = "${config.home.homeDirectory}/other";
    publicShare = "${config.home.homeDirectory}/other";
    extraConfig.XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
  };

  home.stateVersion = "23.11";
}
