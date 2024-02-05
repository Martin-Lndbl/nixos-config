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
    ];
  };
}
