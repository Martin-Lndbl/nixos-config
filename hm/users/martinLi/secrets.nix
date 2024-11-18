{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = [ pkgs.sops ];

  sops = {
    age.keyFile = "/home/martinLi/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets.hello = { };
  };
}
