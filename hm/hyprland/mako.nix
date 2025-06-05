{ config, ... }:

{
  services.mako = with config.colorScheme.palette; {
    enable = true;
    settings = {
      anchor = "top-center";
      height = config.appearance.fontSize * 5;
      width = config.appearance.fontSize * 20;
      defaultTimeout = 10000;
      borderRadius = config.appearance.fontSize;
      backgroundColor = "#${base06}";
      borderColor = "#${base00}";
      textColor = "#${base00}";
    };
  };
}
