{ pkgs, ... }:
{
  programs.ssh =
    {
      enable = true;
      extraConfig = ''
        	Host itsec
        		HostName sandkasten.sec.in.tum.de
        		User team-116

          Host oci
            HostName 141.144.251.241
            User opc
        	'';
    };
}
