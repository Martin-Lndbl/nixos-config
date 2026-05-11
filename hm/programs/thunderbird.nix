{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles."default".isDefault = true;
  };

  wayland.windowManager.hyprland.settings.windowrule = [
    "float yes, match:class thunderbird, match:title Edit Item"
    "float yes, match:class thunderbird, match:title ^$"
    "float yes, match:class thunderbird, match:title Select Calendar"

    "suppress_event maximize, match:class thunderbird, match:title Select Calendar"
    "size 600 400, match:class thunderbird, match:title Select Calendar"
    "center yes, match:class thunderbird, match:title Select Calendar"

    "size 400 500, match:class thunderbird, match:title Uninvited guest"
  ];
}
