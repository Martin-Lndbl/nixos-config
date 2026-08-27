{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  # Icon theme lookup keys off the directory name under share/icons, not the
  # index.theme "Name=" field -- breeze-icons installs to "breeze", lowercase.
  gtk = {
    enable = true;
    iconTheme = {
      name = "breeze";
      package = pkgs.kdePackages.breeze-icons;
    };
  };

  # breeze only inherits hicolor, so keep Adwaita around as a fallback for
  # apps that ship icons under GNOME-style names.
  home.packages = [ pkgs.adwaita-icon-theme ];

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
