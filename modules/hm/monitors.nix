{ config, lib, ... }:

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
    primary_id = mkOption {
      description = "ID of primary monitor";
      type = types.int;
      default = 0;
    };
  };
  options.workspaces = mkOption {
    description = "Workspace definition";
    type = with types; listOf str;
    default = [
      "1"
      "2"
      "3"
      "4"
      "5"
      "6"
      "7"
      "8"
      "9"
    ];
  };

  # TODO: Apply monitor config directly
}
