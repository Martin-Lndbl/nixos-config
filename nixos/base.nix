{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./users.nix
    ./security.nix
  ];

  nixpkgs = {
    overlays = outputs.overlays.modifications;
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

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # virtualisation.docker.enable = true;
  security.allowUserNamespaces = true;
  security.unprivilegedUsernsClone = true;

  # Sound 
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = false;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
      monospace = [ "Noto Sans Mono" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "22.11";
}
