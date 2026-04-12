{ ... }:
{
  virtualisation.xen.enable = true;
  virtualisation.xen.dom0Resources.memory = 8192;
  boot.initrd.systemd.enable = true;
}
