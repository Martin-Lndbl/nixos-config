{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # No SSH host keys here; reuse the home-manager age key.
  sops.age.keyFile = "/home/mrtn/.config/sops/age/keys.txt";
  sops.age.sshKeyPaths = [ ];
  sops.gnupg.sshKeyPaths = [ ];
}
