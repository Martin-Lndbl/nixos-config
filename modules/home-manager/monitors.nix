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
      default = "";
    };
    center = mkOption {
      description = "ID of center monitor";
      type = types.str;
      default = "";
    };
    right = mkOption {
      description = "ID of right monitor";
      type = types.str;
      default = "";
    };
  };
}
