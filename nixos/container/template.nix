{ pkgs, ... }:

let containerName = "template";
in
{
  systemd.nspawn."${containerName}" = {
    execConfig = {
      Boot = false;
      Parameters = "/nix/var/nix/profiles/system/init";
    };
    filesConfig = {
      BindReadOnly = [
        "/nix/store"
        "/nix/var/nix/db"
        "/nix/var/nix/daemon-socket"
      ];
      Bind = [
        "/nix/var/nix/profiles/per-container/${containerName}:/nix/var/nix/profiles"
        "/nix/var/nix/gcroots/per-container/${containerName}:/nix/var/nix/gcroots"
      ];
    };
    networkConfig = {
      Private = true;
    };
  };
}
