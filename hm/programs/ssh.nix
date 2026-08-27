{ ... }:
{
  sshAuthSock = {
    enable = true;
    initialization = {
      bash = ''export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"'';
      fish = ''set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gcr/ssh"'';
      nushell = ''$env.SSH_AUTH_SOCK = ($env.XDG_RUNTIME_DIR | path join "gcr/ssh")'';
    };
    systemd.socketProviderUnit = "gcr-ssh-agent.socket";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/private-config" ];
    settings = {
      "*" = {
        userKnownHostsFile = "~/.ssh/known_hosts";
        addKeysToAgent = "yes";
      };
      "eos" = {
        hostname = "10.10.0.1";
        user = "mrtn";
        identityFile = "~/.ssh/id_eos";
      };
      "pyroeis" = {
        hostname = "172.16.0.1";
        user = "mrtn";
      };
      "rgb" = {
        hostname = "lxhalle.in.tum.de";
        user = "linm";
      };
      "cronus" = {
        user = "mrtn";
        hostname = "192.168.1.105";
      };
      "irene" = {
        hostname = "irene.dos.cit.tum.de";
        user = "mrtn";
        proxyJump = "tunnel@login.dos.cit.tum.de";
      };
      "eliza" = {
        hostname = "eliza.dos.cit.tum.de";
        user = "mrtn";
        proxyJump = "tunnel@login.dos.cit.tum.de";
      };
    };
  };
}
