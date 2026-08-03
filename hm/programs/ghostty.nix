{ config, ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      window-decoration = true;
      window-padding-x = 4;
      window-padding-y = 8;
      confirm-close-surface = false;
      shell-integration-features = "no-cursor";
      font-size = config.appearance.fontSize;
      theme = "${config.xdg.stateHome}/caelestia/theme/ghostty-theme";
    };
  };
}
