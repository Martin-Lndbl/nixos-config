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
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/0".Layout = "us";
          "Groups/0/Items/1".Name = "keyboard-de";
          "Groups/0/Items/1".Layout = "de";
          "Groups/0/Items/2".Name = "mozc";
        };
      };
    };
  };
}
