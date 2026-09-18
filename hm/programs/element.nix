{ pkgs, ... }:
let
  element-desktop = pkgs.symlinkJoin {
    name = "element-desktop-own-sink";
    paths = [ pkgs.element-desktop ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/element-desktop --set PULSE_SINK element
    '';
  };
in
{
  home.packages = [ element-desktop ];

  systemd.user.services.element-sink = {
    Unit = {
      Description = "Virtual sink for Element, muted while caelestia is in do-not-disturb";
      BindsTo = [ "pipewire.service" ];
      After = [ "pipewire.service" ];
    };

    Service = {
      ExecStart = ''
        ${pkgs.pipewire}/bin/pw-loopback \
          --capture-props="media.class=Audio/Sink node.name=element node.description=Element priority.session=0" \
          --playback-props="node.passive=true"
      '';
      Restart = "on-failure";
    };

    Install.WantedBy = [ "pipewire.service" ];
  };
}
