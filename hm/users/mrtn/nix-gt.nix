{ inpugs, pkgs, lib, config, ... }:

{
  imports = [ ./secrets.nix ];

  config.appearance.fontSize = 18;
  config.monitors.center = "DP-2";
  config.monitors.right = "DP-3";
}
