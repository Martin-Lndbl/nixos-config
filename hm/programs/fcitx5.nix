{ pkgs, ... }:
{
  # i18n.inputMethod.enable = true;
  i18n.inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  i18n.inputMethod.fcitx5.waylandFrontend = true;
  i18n.inputMethod.fcitx5.settings.inputMethod = {
    GroupOrder."0" = "Default";
    GroupOrder."1" = "Japanese";
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "de";
      DefaultIM = "keyboard-de";
      item = [
        {
          Name = "keyboard-de";
          index = 0;
        }
      ];
    };

    "Groups/1" = {
      Name = "Japanese";
      "Default Layout" = "de";
      DefaultIM = "mozc";
      item = [
        {
          Name = "mozc";
          index = 0;
        }
      ];
    };
  };
}
