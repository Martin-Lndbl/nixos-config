{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";

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

    # JSTech
    slack

    # communication
    whatsapp-for-linux
    spotifywm
    discord
    zoom-us

    # eyecandy
    neofetch
    cava

    # games
    vitetris

    # PDF stuff
    texlive.combined.scheme-full
    lilypond-with-fonts
  ];

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };

  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

  xdg.configFile."wofi/style.css".source = ./hyprland/wofi.css;
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

  # Programs
  programs = import ./programs {
    inherit pkgs config;
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
