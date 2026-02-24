{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../programs/nvim
    ../../programs/bash.nix
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";
  home.sessionVariables = {
    TERM = "xterm";
  };

  home.packages = with pkgs; [
    clipboard-jh
    btop
  ];

  programs.git.userName = "Martin-Lndbl";
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";

  xdg.enable = true;
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

  home.stateVersion = "25.05";
}
