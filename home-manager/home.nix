{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./programs
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

  colorScheme = inputs.nix-colors.colorSchemes.classic-dark;
  # colorScheme = import ./colorschemes/spacecamp.nix;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.unstable-packages
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

  xdg.configFile."cava/config".source = ./programs/cava;
  xdg.userDirs = {
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/downloads";
    desktop = "${config.home.homeDirectory}/other";
    music = "${config.home.homeDirectory}/other";
    videos = "${config.home.homeDirectory}/other";
    templates = "${config.home.homeDirectory}/other";
    publicShare = "${config.home.homeDirectory}/other";
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
