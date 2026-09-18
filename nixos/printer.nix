{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    # CLX-3170 speaks SPL-C; the samsung blob's filter paths get baked into
    # /etc/cups/ppd and break on the next garbage collection.
    drivers = with pkgs; [ splix ];
  };

  # splix ships no CLX-3170 model; the 3160 is the same SPL-C family
  hardware.printers.ensurePrinters = [
    {
      name = "Samsung_CLX-3170";
      description = "Samsung CLX-3170";
      deviceUri = "dnssd://Samsung%20CLX-3170%20Series%20(Farblaser)._printer._tcp.local/";
      model = "samsung/clx3160.ppd";
    }
  ];
  hardware.printers.ensureDefaultPrinter = "Samsung_CLX-3170";
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
