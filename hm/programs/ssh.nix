{ ... }:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/private-config" ];
    matchBlocks = {
      "*" = {
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
      "eos" = {
        hostname = "10.10.0.1";
        user = "mrtn";
        identityFile = "~/.ssh/id_eos";
      };
      "rgb" = {
        hostname = "lxhalle.in.tum.de";
        user = "linm";
      };
      "cronus" = {
        hostname = "192.168.1.105";
      };
    };
  };
}
