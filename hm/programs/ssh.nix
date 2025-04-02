{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/private-config" ];
    extraConfig = ''
        Host itsec
          HostName sandkasten.sec.in.tum.de
          User team-116

        Host eos
          HostName lndbl.de
          User mrtn
          RequestTTY force
          RemoteCommand bash
          IdentityFile ~/.ssh/id_eos

        Host rgb
          HostName lxhalle.in.tum.de
          User linm
          RequestTTY force
          RemoteCommand bash

        Host cpp
          HostName cppprog.db.in.tum.de
          User git

        Host irene
          HostName irene.dos.cit.tum.de
          User martinLi
          ProxyCommand ssh tunnel@login.dos.cit.tum.de -W %h:%p
          RequestTTY yes
          ForwardX11 no

        Host cronus
          HostName 192.168.1.105
    '';
  };
}
