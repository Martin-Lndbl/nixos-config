{ config, lib, ... }:

let
  cfg = config.monitors;
in
with lib;
{
  options.monitors = {
    left = mkOption {
      description = "ID of left monitor";
      type = types.str;
    };
    center = mkOption {
      description = "ID of left monitor";
      type = types.str;
    };
    right = mkOption {
      description = "ID of left monitor";
      type = types.str;
    };
  };
}
