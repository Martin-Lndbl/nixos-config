# What every greetd setup here needs, whichever greeter (or none) sits on it.
{ pkgs, ... }:
let
  # greetd has no ordering against the GPU and starts ~4s into boot, before
  # the real DRM driver has taken over from simpledrm. Hyprland then aborts in
  # CCompositor::initServer. Measured on a failing boot: Hyprland dumped core
  # at 13:07:32, nvidia-drm only initialised at 13:07:33. SDDM never hit this
  # because its greeter sat there for a minute first. Wait for a card that
  # isn't the EFI framebuffer *and* whose device node has been created.
  waitForDrm = pkgs.writeShellScript "wait-for-drm" ''
    PATH=${pkgs.coreutils}/bin:$PATH
    for _ in $(seq 200); do
      for drv in /sys/class/drm/card*/device/driver; do
        [ -e "$drv" ] || continue
        card=$(basename "$(dirname "$(dirname "$drv")")")
        # skip connectors such as card1-DP-1
        case "$card" in *-*) continue ;; esac
        [ "$(basename "$(readlink -f "$drv")")" = simple-framebuffer ] && continue
        [ -e "/dev/dri/$card" ] && exit 0
      done
      sleep 0.1
    done
    echo "wait-for-drm: no real DRM card after 20s, starting anyway" >&2
  '';
in
{
  services.greetd.enable = true;

  systemd.services.greetd.serviceConfig.ExecStartPre = waitForDrm;

  security.pam.services.greetd.enableGnomeKeyring = true;
}
