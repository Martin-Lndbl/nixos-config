{ pkgs, ... }:
{
  imports = [ ../headless.nix ];

  home.username = "ubuntu";
  home.homeDirectory = "/home/ubuntu";

  # Not NixOS, so nix itself comes from home-manager.
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
