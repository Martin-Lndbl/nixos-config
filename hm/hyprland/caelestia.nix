{ inputs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  stylix.enable = false;

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings.services.smartScheme = false;
    cli.enable = true;
  };
}
