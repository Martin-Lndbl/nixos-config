{ pkgs, ... }:
{
  imports = [ ../headless.nix ];

  home.packages = with pkgs; [ claude-code ];
}
