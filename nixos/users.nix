{ ... }:
{
  users.users.mrtn = {
    isNormalUser = true;
    initialPassword = "pwd";
    # Groups that no enabled service creates are silently dropped by useradd,
    # so only list ones something here actually defines.
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
      "dialout"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLDbWHI/PLBf0hiS0wbHz0ppO/h177fSuRsoZRAq/VD mrtn@mrtnnix-nb"
    ];
  };
}
