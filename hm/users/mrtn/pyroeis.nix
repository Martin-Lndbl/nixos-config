{ pkgs, ... }:
{
  imports = [ ../headless.nix ];

  home.packages = with pkgs; [
    btop
    mdcat
  ];
}
