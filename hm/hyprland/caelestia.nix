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
      qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
        "--prefix" "QT_PLUGIN_PATH" ":" "${pkgs.qt6.qtsvg}/lib/qt-6/plugins"
      ];
      postPatch = (old.postPatch or "") + ''
        substituteInPlace modules/utilities/cards/Record.qml \
          --replace-fail 'import qs.services' 'import Quickshell
import qs.services' \
          --replace-fail 'onClicked: Recorder.start(["-sr"])
                    }
                ]
            }
        }' 'onClicked: Recorder.start(["-sr"])
                    }
                ]
            }

            IconButton {
                shapeMorph: true
                isRound: true
                icon: "photo_camera"
                type: IconButton.Tonal
                font: Tokens.font.icon.medium
                onClicked: Quickshell.execDetached(["grimblast", "copy", "area"])

                implicitWidth: {
                    const h = label.implicitHeight + Tokens.padding.large * 2;
                    if (h % 2 !== 0) return h + 1;
                    return h;
                }
            }
        }'

        substituteInPlace modules/bar/components/workspaces/Workspace.qml \
          --replace-fail '    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: size' '    visible: root.isOccupied || root.activeWsId === root.ws
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: size'

        substituteInPlace services/Colours.qml \
          --replace-fail 'Hypr.extras.batchMessage([rule.arg("blur").arg(trEnabled), rule.arg("ignore_alpha").arg(Math.max(0, transparency.base - 0.03))]);' 'Hypr.extras.batchMessage([rule.arg("blur").arg(trEnabled), rule.arg("ignore_alpha").arg(Math.max(0, transparency.base - 0.03))]);
        const winOpacity = (transparency.enabled ? transparency.base : 1).toFixed(3);
        Quickshell.execDetached(["hyprctl", "keyword", "decoration:active_opacity", winOpacity]);
        Quickshell.execDetached(["hyprctl", "keyword", "decoration:inactive_opacity", winOpacity]);'
      '';
    });
    cli = {
      enable = true;
      settings.theme.postHook = "pkill -USR2 ghostty || true";
      package = inputs.caelestia-shell.inputs.caelestia-cli.packages.${pkgs.system}.default.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          echo "=== caelestia custom-scheme injection ==="
          schemedir=$(find $out -type d -path '*/caelestia/data/schemes' -print -quit)
          echo "found schemedir: $schemedir"
          if [ -z "$schemedir" ]; then
            echo "ERROR: caelestia schemes directory not found in $out" >&2
            find $out -type d 2>&1 | head -60 >&2
            exit 1
          fi
          cp -rv ${./schemes}/. "$schemedir/"
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
      base03 = '#{{ surfaceContainerHigh.hex }}',
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
