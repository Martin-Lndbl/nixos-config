{ inputs, pkgs, config, ... }:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = [ pkgs.sops ];

  sops = {
    age.keyFile = "/home/mrtn/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets.openweathermap = { };
    secrets.apininja = { };
    secrets.wakatime = { };
  };
}
