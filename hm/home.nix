{
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ./programs
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

  appearance.profile.picture = import ../avatar.nix pkgs;
  home.file.".face".source = config.appearance.profile.picture;

  home.packages = with pkgs; [
    universal-ctags
    xdg-utils
    unzip
    fd
    xclip
    acpi
    swaybg
    brightnessctl
    ripgrep
    btop
    claude-code
    gh

    # meetings
    discord
    element-desktop

    # Notes
    trilium-desktop

    nautilus

    # Browser
    tor-browser

    # eyecandy
    cava
  ];

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 28;
  };

  xdg.enable = true;
  xdg.cacheHome = config.home.homeDirectory + "/.local/cache";
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    desktop = "${config.home.homeDirectory}/.local/share/applications";
    pictures = "${config.home.homeDirectory}/other/pictures";
    music = "${config.home.homeDirectory}/other/music";
    videos = "${config.home.homeDirectory}/other/videos";
    templates = "${config.home.homeDirectory}/other";
    publicShare = "${config.home.homeDirectory}/other";
    extraConfig.SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
