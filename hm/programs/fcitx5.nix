{ pkgs, config, ... }:
{
  fcitx5 = {
    enable = true;
    profile.groups = {
      Default = {
        "Default Layout" = "de";
        DefaultIM = "keyboard-de";
        item = [
          {
            Name = "keyboard-de";
            index = 0;
          }
        ];
      };

      Japanese = {
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

    profile.groupOrder = {
      Default = 0;
      Japanese = 1;
    };

    config.Hotkey = {
      TriggerKeys = [ ];
      EnumerateWithTriggerKeys = false;
      AltTriggerKeys = [ ];
      EnumerateForwardKeys = [ ];
      EnumerateBackwardKeys = [ ];
      EnumerateGroupBackwardKeys = [ ];
      ActivateKeys = [ ];
      DeactivateKeys = [ ];
      PrevPage = [ ];
      NextPage = [ ];
      TogglePreedit = [ ];
    };
  };
}
