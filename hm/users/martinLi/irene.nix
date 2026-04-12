{
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

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";

  programs.bash.bashrcExtra = "source ~/.profile";
  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    mdcat
    clipboard-jh
  ];

  home.sessionVariables = {
    TERM = "xterm";
  };


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

  home.stateVersion = "25.11";
}
