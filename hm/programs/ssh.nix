{ pkgs, ... }:
{
  programs.ssh =
    {
      enable = true;
      extraConfig = ''
        	Host itsec
        		HostName sandkasten.sec.in.tum.de
        		User team-116
        	'';
    };
}
