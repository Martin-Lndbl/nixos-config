# SDDM greeter. Both the GNOME (`nixos/wm/gnome.nix`) and Hyprland
# (`nixos/wm/hyprland.nix`) sessions register with the display manager,
# so the user can pick either one from the login screen's session menu.
# `defaultSession` controls which is preselected.
{ pkgs, ... }:

let
  # sddm-astronaut selects its active variant via the `ConfigFile` line in
  # metadata.desktop. Override the packaged theme to point at hyprland_kath.
  astronaut = pkgs.sddm-astronaut.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      substituteInPlace $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop \
        --replace-fail 'ConfigFile=Themes/astronaut.conf' \
                       'ConfigFile=Themes/hyprland_kath.conf'
    '';
  });
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [
      astronaut
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qtvirtualkeyboard
      pkgs.kdePackages.qtmultimedia
    ];
    settings = {
      General = {
        # Cursor needs to be readable by the `sddm` system user, so ship it
        # in systemPackages (below) rather than only via home-manager.
        CursorTheme = "phinger-cursors-light";
        CursorSize = 28;
      };
    };
  };
  services.displayManager.defaultSession = "hyprland";

  # Make the cursor and theme QML available to SDDM's session.
  environment.systemPackages = [
    pkgs.phinger-cursors
    astronaut
  ];
}
