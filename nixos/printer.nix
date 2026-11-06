{ pkgs, ... }:
let
  # The CLX-3170 rejects splix's QPDL ("please use the proper driver"); it
  # needs Samsung's own SPL-C filter. nixpkgs bakes the filter's store path
  # into the PPDs, which turns stale once the path is garbage collected, so
  # keep the plain `pstosplc` name: cups resolves it via ServerBin, where
  # every driver's filters are linked.
  samsungDriver = pkgs.samsung-unified-linux-driver.overrideAttrs { ppdFileCommands = [ ]; };
in
{
  services.printing = {
    enable = true;
    drivers = [ samsungDriver ];
  };

  hardware.printers.ensurePrinters = [
    {
      name = "Samsung_CLX-3170";
      description = "Samsung CLX-3170";
      deviceUri = "dnssd://Samsung%20CLX-3170%20Series%20(Farblaser)._printer._tcp.local/";
      model = "samsung/CLX-3170.ppd";
    }
  ];
  hardware.printers.ensureDefaultPrinter = "Samsung_CLX-3170";
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
