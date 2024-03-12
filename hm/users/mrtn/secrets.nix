{ inputs, pkgs, config, ... }:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = [ pkgs.sops ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/mrtn/.config/sops/age/keys.txt";

  sops.secrets.openweathermap = { };
  sops.secrets.apininja = { };
  sops.secrets.wakatime = { };
}
