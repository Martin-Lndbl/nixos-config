{ inputs, lib, config, pkgs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  xdg.configFile."caelestia/shell.json".force = true;
  xdg.configFile."caelestia/cli.json".force = true;

  home.activation.caelestiaMutableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for f in "$HOME/.config/caelestia/shell.json" "$HOME/.config/caelestia/cli.json"; do
      if [ -L "$f" ]; then
        target=$(readlink -f "$f")
        rm "$f"
        cp "$target" "$f"
        chmod u+w "$f"
      fi
    done
  '';

  home.activation.caelestiaRepairMonitorConfigs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for f in "$HOME/.config/caelestia/monitors/"*/shell.json; do
      [ -f "$f" ] && [ ! -s "$f" ] && echo '{}' > "$f"
    done
  '';

  home.activation.caelestiaSeedGhosttyTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target="$HOME/.local/state/caelestia/theme/ghostty-theme"
    if [ ! -e "$target" ]; then
      mkdir -p "$(dirname "$target")"
      cat > "$target" <<'EOF'
    background = 181818
    foreground = d8d8d8
    cursor-color = 7cafc2
    selection-background = 383838
    selection-foreground = d8d8d8
    palette = 0=#181818
    palette = 1=#ab4642
    palette = 2=#a1b56c
    palette = 3=#f7ca88
    palette = 4=#7cafc2
    palette = 5=#ba8baf
    palette = 6=#86c1b9
    palette = 7=#d8d8d8
    palette = 8=#585858
    palette = 9=#ab4642
    palette = 10=#a1b56c
    palette = 11=#f7ca88
    palette = 12=#7cafc2
    palette = 13=#ba8baf
    palette = 14=#86c1b9
    palette = 15=#f8f8f8
    EOF
    fi
  '';

  programs.caelestia = {
    enable = true;
    settings.paths.wallpaperDir = "${config.xdg.userDirs.pictures}/wallpaper";
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [
        "PATH=/run/wrappers/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
        "XDG_VIDEOS_DIR=${config.xdg.userDirs.videos}"
        "XDG_PICTURES_DIR=${config.xdg.userDirs.pictures}"
      ];
    };
    package = inputs.caelestia-shell.packages.${pkgs.system}.default.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace modules/utilities/cards/Record.qml \
          --replace-fail 'import qs.services' 'import Quickshell
                import qs.services' \
          --replace-fail '                        onClicked: Recorder.start(["-sr"])
                            }
                        ]
                    }
                }' '                        onClicked: Recorder.start(["-sr"])
                            }
                        ]
                    }

                    IconButton {
                        shapeMorph: true
                        isRound: true
                        icon: "photo_camera"
                        type: IconButton.Tonal
                        font: Tokens.font.icon.medium
                        onClicked: {
                            root.screenState.utilities = false;
                            Quickshell.execDetached(["sh", "-c", "sleep 0.3 && grimblast copy area"]);
                        }

                        implicitWidth: {
                            const h = label.implicitHeight + Tokens.padding.large * 2;
                            if (h % 2 !== 0) return h + 1;
                            return h;
                        }
                    }
                }'

        substituteInPlace modules/session/Content.qml \
          --replace-fail '    AnimatedImage {
                width: Tokens.sizes.session.button
                height: Tokens.sizes.session.button
                sourceSize.width: width * ((QsWindow.window as QsWindow)?.devicePixelRatio ?? 1)

                playing: visible
                asynchronous: true
                speed: Config.general.sessionGifSpeed
                source: Paths.absolutePath(Config.paths.sessionGif)
                fillMode: AnimatedImage.PreserveAspectFit
            }' '    Item {}' \
          --replace-fail '    SessionButton {
                id: logout

                icon: Config.session.icons.logout
                command: Config.session.commands.logout

                KeyNavigation.down: shutdown' '    SessionButton {
                id: lock

                icon: "lock"
                command: ["caelestia-shell", "ipc", "call", "lock", "lock"]

                KeyNavigation.down: logout
            }

            SessionButton {
                id: logout

                icon: Config.session.icons.logout
                command: Config.session.commands.logout

                KeyNavigation.up: lock
                KeyNavigation.down: shutdown'

        substituteInPlace modules/sidebar/NotifActionList.qml \
          --replace-fail '                            } else if (action.modelData.invoke) {
                                        action.modelData.invoke();
                                    } else if (!root.notif.resident) {' '                            } else if (action.modelData.invoke) {
                                        action.modelData.invoke();
                                        Quickshell.execDetached(["hyprctl", "dispatch", "focuswindow", "class:^(?i)" + root.notif.appName + "$"]);
                                    } else if (!root.notif.resident) {'

        substituteInPlace modules/bar/components/workspaces/Workspace.qml \
          --replace-fail '    Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: size' '    visible: root.isOccupied || root.activeWsId === root.ws
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: size'

        substituteInPlace modules/dashboard/dash/DateTime.qml \
          --replace-fail '            text: Time.minuteStr
                    color: Colours.palette.m3secondary
                    font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
                }

                Loader {' '            text: Time.minuteStr
                    color: Colours.palette.m3secondary
                    font: Tokens.font.clock.size(28).weight(Font.DemiBold).build()
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.format("ss")
                    color: Colours.palette.m3primary
                    font: Tokens.font.clock.size(18).weight(Font.DemiBold).build()
                }

                Loader {'

        substituteInPlace modules/dashboard/dash/DateTime.qml \
          --replace-fail '        spacing: 0

                StyledText {
                    Layout.bottomMargin: -(font.pointSize * 0.4)
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.hourStr' '        spacing: 0

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.format("dddd")
                    color: Colours.palette.m3primary
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 8
                    text: Time.format("MMM d")
                    color: Colours.palette.m3secondary
                }

                StyledText {
                    Layout.bottomMargin: -(font.pointSize * 0.4)
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.hourStr'
      '';
    });
    cli = {
      enable = true;
      settings.theme.postHook = "pkill -USR2 ghostty || true";
      package = inputs.caelestia-shell.inputs.caelestia-cli.packages.${pkgs.system}.default.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          schemedir=$(find $out -type d -path '*/caelestia/data/schemes' -print -quit)
          if [ -z "$schemedir" ]; then
            echo "ERROR: caelestia schemes directory not found in $out" >&2
            exit 1
          fi
          cp -r ${./schemes}/. "$schemedir/"
        '';
      });
    };
  };

  xdg.configFile."caelestia/templates/ghostty-theme".text = ''
    background = {{ background.hex }}
    foreground = {{ onSurface.hex }}
    cursor-color = {{ primary.hex }}
    selection-background = {{ surfaceContainerHigh.hex }}
    selection-foreground = {{ onSurface.hex }}
    palette = 0=#{{ term0.hex }}
    palette = 1=#{{ term1.hex }}
    palette = 2=#{{ term2.hex }}
    palette = 3=#{{ term3.hex }}
    palette = 4=#{{ term4.hex }}
    palette = 5=#{{ term5.hex }}
    palette = 6=#{{ term6.hex }}
    palette = 7=#{{ term7.hex }}
    palette = 8=#{{ term8.hex }}
    palette = 9=#{{ term9.hex }}
    palette = 10=#{{ term10.hex }}
    palette = 11=#{{ term11.hex }}
    palette = 12=#{{ term12.hex }}
    palette = 13=#{{ term13.hex }}
    palette = 14=#{{ term14.hex }}
    palette = 15=#{{ term15.hex }}
  '';

  xdg.configFile."caelestia/templates/base16-nvim.lua".text = ''
    return {
      base00 = '#{{ background.hex }}',
      base01 = '#{{ surfaceContainerLow.hex }}',
      base02 = '#{{ surfaceContainer.hex }}',
      base03 = '#{{ outline.hex }}',
      base04 = '#{{ subtext0.hex }}',
      base05 = '#{{ onSurface.hex }}',
      base06 = '#{{ onBackground.hex }}',
      base07 = '#{{ text.hex }}',
      base08 = '#{{ red.hex }}',
      base09 = '#{{ peach.hex }}',
      base0A = '#{{ yellow.hex }}',
      base0B = '#{{ green.hex }}',
      base0C = '#{{ teal.hex }}',
      base0D = '#{{ blue.hex }}',
      base0E = '#{{ mauve.hex }}',
      base0F = '#{{ maroon.hex }}',
    }
  '';
}
