{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles."default".isDefault = true;
  };

  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match = {
        class = "thunderbird";
        title = "Edit Item";
      };
      float = true;
    }
    {
      match = {
        class = "thunderbird";
        title = "^$";
      };
      float = true;
    }
    {
      match = {
        class = "thunderbird";
        title = "Select Calendar";
      };
      float = true;
      suppress_event = "maximize";
      size = "600 400";
      center = true;
    }
    {
      match = {
        class = "thunderbird";
        title = "Uninvited guest";
      };
      size = "400 500";
    }
  ];
}
