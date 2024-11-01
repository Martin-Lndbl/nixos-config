{ ... }:
{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./calc.nix
    ./cava.nix
    ./discord.nix
    ./fcitx5.nix
    ./firefox.nix
    ./git.nix
    ./mime.nix
    ./nvim
    ./oci.nix
    ./spotify.nix
    ./ssh.nix
    ./vscode.nix
    ./whatsapp.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
