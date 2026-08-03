{ inputs, lib, config, pkgs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  home.activation.caelestiaSetWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${config.programs.caelestia.cli.package}/bin/caelestia wallpaper -f ${config.appearance.wallpaper} || true
  '';

  home.activation.caelestiaSeedGhosttyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
    };
    cli.enable = true;
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
