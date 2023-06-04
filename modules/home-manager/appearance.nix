{ config, lib, ... }:

let
  cfg = config.appearance;
in
with lib;
{
  options.appearance = {
    fontSize = mkOption {
      description = "Font Size of default terminal";
      type = types.int;
      default = 14;
    };
  };
}
