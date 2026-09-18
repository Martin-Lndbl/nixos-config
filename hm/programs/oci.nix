{ config, pkgs, ... }:
{
  home.packages = [ pkgs.oci-cli ];

  home.sessionVariables.OCI_CLI_RC_FILE = "${config.home.homeDirectory}/.oci/config";
}
