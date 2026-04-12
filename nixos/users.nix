{ config, pkgs, ... }:
{
  users.users.mrtn = {
    isNormalUser = true;
    initialPassword = "pwd";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "scanner"
      "networkmanager"
      "docker"
      "dialout"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLDbWHI/PLBf0hiS0wbHz0ppO/h177fSuRsoZRAq/VD mrtn@mrtnnix-nb"
    ];
  };
}
