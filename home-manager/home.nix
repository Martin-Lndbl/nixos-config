{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./programs
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

  # colorScheme = inputs.nix-colors.colorSchemes.classic-light;
  colorScheme = import ./colorschemes/spacecamp.nix;

  nixpkgs = {
    overlays = outputs.overlays.modifications ;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    unzip
    calc
    universal-ctags
    fd
    xclip
    acpi
    swaybg
    brightnessctl
    grim

    # PP-R
    rstudio

    # communication
    whatsapp-for-linux
    spotifywm
    discord
    zoom-us
    # slack

    # Notes
    trilium-desktop

    # eyecandy
    neofetch
    cava

    # games
    vitetris

    # PDF stuff
    zathura
    texlive.combined.scheme-full
  ];

  xdg.configFile."cava/config".source = ./programs/cava;
  xdg.userDirs = {
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/downloads";
    desktop = config.home.homeDirectory;
    music = config.home.homeDirectory;
    videos = config.home.homeDirectory;
    templates = config.home.homeDirectory;
    publicShare = config.home.homeDirectory;
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
