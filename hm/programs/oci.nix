{ pkgs, ... }:
{
  home.packages = [ pkgs.oci-cli ];

  home.sessionVariables = {
    OCI_CLI_RC_FILE = "/home/mrtn/.oci/config";
  };
}
