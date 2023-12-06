{ inputs, outputs, lib, config, pkgs, ... }: {

  services.xserver = {
    enable = true;
    layout = "de";
    xkbOptions = "eurosign:e";
    windowManager.i3.enable = true;
  };

}
