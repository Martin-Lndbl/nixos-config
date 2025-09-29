{ config, ... }:

{
  services.mako = with config.colorScheme.palette; {
    enable = true;
    settings = {
      anchor = "top-center";
      height = config.appearance.fontSize * 5;
      width = config.appearance.fontSize * 20;
      default-timeout = 10000;
      border-radius = config.appearance.fontSize;
      background-color = "#${base06}";
      border-color = "#${base00}";
      text-color = "#${base00}";
    };
  };
}
