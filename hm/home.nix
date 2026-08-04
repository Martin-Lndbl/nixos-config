{
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

  appearance.profile.picture = pkgs.fetchurl {
    url = "https://avatars.githubusercontent.com/u/77677509?v=4";
    hash = "sha256-xUB6FICXhoX8lK/tZI9yiVAY2VFuKXePwGnhQhKHWg0=";
  };
  home.file.".face".source = config.appearance.profile.picture;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.nixpkgs-stable
    ]
    ++ outputs.overlays.modifications;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    universal-ctags
    xdg-utils
    unzip
    calc
    fd
    xclip
    acpi
    swaybg
    brightnessctl
    ripgrep
    btop

    # meetings
    discord
    element-desktop

    # Notes
    trilium-desktop

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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  xdg.enable = true;
  xdg.cacheHome = config.home.homeDirectory + "/.local/cache";
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
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
