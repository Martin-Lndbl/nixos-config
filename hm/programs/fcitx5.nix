{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  # Must be Papirus. Applying a caelestia theme (which happens on every
  # wallpaper/scheme change) unconditionally runs
  #   dconf write /org/gnome/desktop/interface/icon-theme 'Papirus-<mode>'
  # unless cli.settings.theme.iconTheme overrides it, and GTK -- and so the
  # qgtk3 Qt platform theme -- prefers that dconf value over settings.ini.
  # Anything else here gets silently clobbered the next time the theme is
  # applied, leaving icons unresolvable. Papirus-Dark inherits breeze-dark and
  # hicolor, both shipped by the same package.
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      # No ignoreUserConfig: it sets SKIP_FCITX_USER_PATH=1, which makes fcitx5
      # skip ~/.config/fcitx5 - the only place this module writes the profile.
      addons = with pkgs; [
        fcitx5-mozc
      ];
      settings = {
        globalOptions.Behaviour = {
          ShowInputMethodInformation = false;
          ShowFirstInputMethodInformation = false;
        };
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
