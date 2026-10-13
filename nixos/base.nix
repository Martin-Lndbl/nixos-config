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
    ./users.nix
    ./security.nix
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45min";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
    randomizedDelaySec = "45min";
  };
  systemd.services.nix-gc.serviceConfig = {
    Nice = 19;
    CPUSchedulingPolicy = "idle";
    IOSchedulingClass = "idle";
  };
  systemd.services.nix-optimise.serviceConfig = {
    Nice = 19;
    CPUSchedulingPolicy = "idle";
    IOSchedulingClass = "idle";
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    sandbox = true;
  };

  services.journald.settings.Journal = {
    SystemMaxUse = "512M";
    SystemMaxFileSize = "64M";
  };

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Berlin";
  # time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Let the graph clock follow the stream rate instead of resampling every
    # 44.1 kHz source (most music) to the 48 kHz default.
    extraConfig.pipewire."10-rates"."context.properties" = {
      "default.clock.allowed-rates" = [ 44100 48000 96000 ];
    };
  };

  environment.etc."openal/alsoft.conf".text = ''
    drivers=pulse,alsa
  '';

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
  };

  # virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    ethtool
  ];

  services.gnome.gnome-keyring.enable = true;

  security.pki.certificateFiles = [
    ./eos.pem
  ];

  system.stateVersion = "26.11";
}
