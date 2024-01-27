{ pkgs, config, ... }:

{
  services.mako = {
    enable = true;
    anchor = "top-center";
    height = config.appearance.fontSize * 5;
    width = config.appearance.fontSize * 20;
    defaultTimeout = 10000;
    borderRadius = config.appearance.fontSize;
    backgroundColor = "#${config.colorScheme.colors.base06}";
    borderColor = "#${config.colorScheme.colors.base00}";
    textColor = "#${config.colorScheme.colors.base00}";
  };
}
