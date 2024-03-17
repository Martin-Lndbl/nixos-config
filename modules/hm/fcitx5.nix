{ pkgs, config, lib, ... }:

with lib;
with builtins;
let
  cfg = config.fcitx5;
  iniFormat = pkgs.formats.ini { };

  refactor = parent: name: value:
    if isList value then
      {
        "${parent}/${name}" = listToAttrs
          (lists.imap0 (i: v: { name = toString i; value = v; }) value);
      }
    else { ${parent}.${name} = value; };

  configFile = iniFormat.generate "config"
    (attrsets.foldlAttrs
      (acc: name: value: recursiveUpdate acc (refactor "Hotkey" name value))
      { inherit (cfg.config) Behaviour; }
      cfg.config.Hotkey);

  expand = name: value:
    attrsets.foldlAttrs
      (acc: n: v:
        recursiveUpdate acc (
          if n != "item"
          then
            { ${name} = { ${n} = v; }; }
          else
            builtins.listToAttrs
              (lists.imap0
                (index: val:
                  nameValuePair
                    "${name}/Items/${toString val.index}"
                    (attrsets.filterAttrs (a: b: a != "index") val))
                v)
        )
      )
      { }
      value;

  profileFile = with attrsets;
    pipe cfg.profile.groupOrder
      [
        (# Merge active groups from groupOrder with config
          mapAttrs'
            (name: value: nameValuePair
              "Groups/${toString value}"
              (cfg.profile.groups.${name}))
        )

        (# Rename "item" list of every group and move to toplevel
          foldlAttrs
            (acc: name: value:
              recursiveUpdate
                acc
                (expand name value))
            { }
        )

        (
          # Include reversed groupOrder in config
          acm:
          foldlAttrs
            (acc: name: value:
              recursiveUpdate
                acc
                { "GroupOrder" = { ${toString value} = name; }; })
            acm
            cfg.profile.groupOrder
        )

        (iniFormat.generate "profile")
      ];

in
{
  options.fcitx5 = with types; {
    enable = mkEnableOption "Fcitx5 configuration with home-manager";
    config.Hotkey = {
      TriggerKeys = mkOption {
        description = "Trigger Input Method";
        type = listOf str;
        default = [ "Control+space" "Zenkaku_Hankaku" "Hangul" ];
        example = [ ];
      };
      EnumerateWithTriggerKeys = mkOption {
        description = "Enumerate when press trigger key repeatedly";
        type = bool;
        default = true;
        example = false;
      };
      AltTriggerKeys = mkOption {
        description = "Temporally switch between first and current Input Method";
        type = listOf str;
        default = [ "Shift_L" ];
        example = [ ];
      };
      EnumerateForwardKeys = mkOption {
        description = "Enumerate Input Method Forward";
        type = listOf str;
        default = [ ];
      };
      EnumerateBackwardKeys = mkOption {
        description = "Enumerate Input Method Backward";
        type = listOf str;
        default = [ ];
      };
      EnumerateSkipFirst = mkOption {
        description = "Skip first input method while enumerating";
        type = bool;
        default = false;
        example = true;
      };
      EnumerateGroupForwardKeys = mkOption {
        description = "Enumerate Input Method Group Forward";
        type = listOf str;
        default = [ "Super+space" ];
        example = [ ];
      };
      EnumerateGroupBackwardKeys = mkOption {
        description = "Enumerate Input Method Group Backward";
        type = listOf str;
        default = [ "Shift+Super+space" ];
        example = [ ];
      };
      ActivateKeys = mkOption {
        description = "Activate Input Method";
        type = listOf str;
        default = [ "Hangul_Hanja" ];
        example = [ ];
      };
      DeactivateKeys = mkOption {
        description = "Deactivate Input Method";
        type = listOf str;
        default = [ "Hangul_Romaja" ];
        example = [ ];
      };
      PrevPage = mkOption {
        description = "Default Previous page";
        type = listOf str;
        default = [ "Up" ];
        example = [ ];
      };
      NextPage = mkOption {
        description = "Default Next page";
        type = listOf str;
        default = [ "Down" ];
        example = [ ];
      };
      PrevCandidate = mkOption {
        description = "Default Previous Candidate";
        type = listOf str;
        default = [ "Shift+Tab" ];
        example = [ ];
      };
      NextCandidate = mkOption {
        description = "Default Next Candidate";
        type = listOf str;
        default = [ "Tab" ];
        example = [ ];
      };
      TogglePreedit = mkOption {
        description = "Toggle embedded preedit";
        type = listOf str;
        default = [ "Control+Alt+P" ];
        example = [ ];
      };
    };
    config.Behaviour = {
      ActiveByDefault = mkOption {
        description = "Active By Default";
        type = bool;
        default = false;
        example = true;
      };
      ShareInputState = mkOption {
        description = "Share Input State";
        type = str;
        default = "No";
        example = "Program";
      };
      PreeditEnabledByDefault = mkOption {
        description = "Show preedit in application";
        type = bool;
        default = true;
        example = false;
      };
      ShowInputMethodInformation = mkOption {
        description = "Show Input Method Information when switch input method";
        type = bool;
        default = true;
        example = false;
      };
      showInputMethodInformationWhenFocusIn = mkOption {
        description = "Show Input Method Information when changing focus";
        type = bool;
        default = false;
        example = true;
      };
      CompactInputMethodInformation = mkOption {
        description = "Show compact input method information";
        type = bool;
        default = true;
        example = false;
      };
      ShowFirstInputMethodInformation = mkOption {
        description = "Show first input method information";
        type = bool;
        default = true;
        example = false;
      };
      DefaultPageSize = mkOption {
        description = "Default page size";
        type = int;
        default = 5;
        example = 10;
      };
      OverrideXkbOption = mkOption {
        description = "OverrideXkbOption";
        type = bool;
        default = false;
        example = true;
      };
      CustomXkbOption = mkOption {
        description = "Custom Xkb Option";
        type = str;
        default = "";
      };
      EnableAddons = mkOption {
        # TODO: what is this?
        description = "Force Enabled Addons";
        type = str;
        default = "";
      };
      DisableAddons = mkOption {
        description = "Forward Disabled Addons";
        type = str;
        default = "";
      };
      PreloadInputMethod = mkOption {
        description = "Preload input method to be used by default";
        type = bool;
        default = true;
        example = false;
      };
      AllowInputMethodForPassword = mkOption {
        description = "Allow input method in the password field";
        type = bool;
        default = false;
        example = true;
      };
      ShowPreeditForPassword = mkOption {
        description = "Show preedit text when typing password";
        type = bool;
        default = false;
        example = true;
      };
      AutoSavePeriod = mkOption {
        description = "Interval of saving user data in minutes";
        type = int;
        default = 30;
        example = 60;
      };
    };

    profile = {
      groups = mkOption {
        description = "Define groups to switch between";
        type = attrsOf
          (submodule
            (
              { name, options, config, ... }:
              {
                options = {
                  "Default Layout" = mkOption {
                    description = "Layout";
                    type = str;
                    example = "us";
                  };
                  DefaultIM = mkOption {
                    description = "Default Input Method";
                    type = str;
                    example = "keyboard-us";
                  };
                  Name = mkOption {
                    type = str;
                    default = name;
                  };
                  item = mkOption
                    {
                      description = "Define different keyboard layouts to switch between";
                      type = listOf (submodule (
                        { options, ... }:
                        {
                          options = {
                            Name = mkOption {
                              description = "Name of keyboard layout";
                              type = str;
                              example = "keyboard-us";
                            };
                            Layout = mkOption {
                              type = str;
                              default = "";
                            };
                            index = mkOption {
                              description = "Position of item in list";
                              type = ints.unsigned;
                              example = 0;
                            };
                          };
                        }
                      ));
                    };
                };
              }
            ));
      };
      groupOrder =
        mkOption
          {
            description = "Starting from 0. Only groups listed here will be written to config";
            type = attrsOf ints.unsigned;
            example = { Default = 0; Japanese = 1; };
          };
    };
  };
  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
      ];
    };

    # TODO: prevent fcitx5 from starting on startup

    # whole folder needs to be linked, since fcitx5 overwrites symlinks otherwise
    xdg.configFile.fcitx5.source = pkgs.runCommand "fcitx5-config" { } ''
      mkdir $out
      ln -s ${configFile} $out/config
      ln -s ${profileFile} $out/profile
    '';
  };
}
