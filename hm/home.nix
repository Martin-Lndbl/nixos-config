{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
    ./games
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

  colorScheme = inputs.nix-colors.colorSchemes.classic-dark;
  appearance.profile.picture = "${config.xdg.userDirs.pictures}/profile.jpeg";

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.nixpkgs-stable
    ] ++ outputs.overlays.modifications;
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
    trilium-desktop-pkg
    xournalpp
    anki

    # Browser
    tor-browser

    # eyecandy
    neofetch
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

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
