{ pkgs, ... }: {

  imports = [
    ./i3status.nix
  ];

  xsession.windowManager.i3 = {

    enable = true;
    config = null;
    extraConfig = builtins.readFile ./config;
  };
}
