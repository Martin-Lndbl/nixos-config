{ ... }:
{
  imports = [ ./dos-cluster.nix ];

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".addKeysToAgent = "yes";
  };
}
