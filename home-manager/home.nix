{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./programs
    ./games
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

  colorScheme = inputs.nix-colors.colorSchemes.brewer;
  # colorScheme = import ./colorschemes/spacecamp.nix;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ] ++ outputs.overlays.modifications;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "electron-24.8.6"
      ];
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
    grim
    ripgrep

    # communication
    whatsapp-for-linux
    discord
    zoom-us

    # Notes
    trilium-desktop
    anki

    # eyecandy
    neofetch
    cava

    # PDF stuff
    zathura
    texlive.combined.scheme-full
  ];

  xdg.enable = true;
  xdg.cacheHome = config.home.homeDirectory + "/.local/cache";
  xdg.mimeApps.enable = true;
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

  home.stateVersion = "22.11";
}
