{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    # CLX-3170 speaks SPL-C; the samsung blob's filter paths get baked into
    # /etc/cups/ppd and break on the next garbage collection.
    drivers = with pkgs; [ splix ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
