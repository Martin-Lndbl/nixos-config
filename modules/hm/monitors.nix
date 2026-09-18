{ lib, ... }:

let
  inherit (lib) mkOption types;
  monitor =
    side:
    mkOption {
      description = "ID of ${side} monitor";
      type = types.str;
      default = "";
    };
in
{
  options.monitors = {
    center = monitor "center";
    right = monitor "right";
  };

  options.workspaces = mkOption {
    description = "Workspace definition";
    type = types.listOf types.str;
    default = map toString (lib.range 1 9);
  };
}
