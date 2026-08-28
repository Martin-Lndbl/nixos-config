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

  appearance.profile.picture = pkgs.fetchurl {
    url = "https://avatars.githubusercontent.com/u/77677509?v=4";
    hash = "sha256-xUB6FICXhoX8lK/tZI9yiVAY2VFuKXePwGnhQhKHWg0=";
  };
  home.file.".face".source = config.appearance.profile.picture;

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
    claude-code
    gh

    # meetings
    discord
    element-desktop

    # Notes
    trilium-desktop

    nautilus

    # Keyring management. Both used to come in via the GNOME closure; with
    # autologin the login keyring needs an empty password to unlock unattended,
    # and seahorse is the only way to change it.
    seahorse
    libsecret

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
