{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./users.nix
    ./security.nix
    ./japanese.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.fallbackpkgs
    ] ++ outputs.overlays.modifications;
    config.allowUnfree = true;
  };

  nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # time.timeZone = "Europe/Berlin";
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Sound 
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.etc."/openal/alsoft.conf".text = ''
    drivers=pulse,alsa
  '';

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "22.11";
}
