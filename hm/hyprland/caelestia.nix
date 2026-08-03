{ inputs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    cli.enable = true;
  };

  xdg.configFile."caelestia/templates/base16-nvim.lua".text = ''
    return {
      base00 = '#{{ background.hex }}',
      base01 = '#{{ surfaceContainerLow.hex }}',
      base02 = '#{{ surfaceContainer.hex }}',
      base03 = '#{{ surfaceContainerHigh.hex }}',
      base04 = '#{{ subtext0.hex }}',
      base05 = '#{{ onSurface.hex }}',
      base06 = '#{{ onBackground.hex }}',
      base07 = '#{{ text.hex }}',
      base08 = '#{{ red.hex }}',
      base09 = '#{{ peach.hex }}',
      base0A = '#{{ yellow.hex }}',
      base0B = '#{{ green.hex }}',
      base0C = '#{{ teal.hex }}',
      base0D = '#{{ blue.hex }}',
      base0E = '#{{ mauve.hex }}',
      base0F = '#{{ maroon.hex }}',
    }
  '';
}
