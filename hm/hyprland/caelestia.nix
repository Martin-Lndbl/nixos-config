{ inputs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  stylix.targets.gtk.enable = false;
  stylix.targets.qt.enable = false;
  stylix.targets.fuzzel.enable = false;
  stylix.targets.hyprland.enable = false;

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
