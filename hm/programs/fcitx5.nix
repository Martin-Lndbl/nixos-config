{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
      settings = {
        globalOptions.Hotkey.ToggleInputMethod = "Super+Space";
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "de";
            DefaultIM = "keyboard-de";
          };
          "Groups/0/Items/0".Name = "keyboard-de";
          "Groups/0/Items/1".Name = "mozc";
        };
      };
    };
  };
}
