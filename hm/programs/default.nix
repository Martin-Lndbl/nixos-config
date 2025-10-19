{ ... }:
{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./calc.nix
    ./cava.nix
    # ./discord.nix
    ./fcitx5.nix
    ./firefox.nix
    ./git.nix
    ./mime.nix
    ./nvim
    ./spotify.nix
    ./ssh.nix
    ./thunderbird.nix
    ./oci.nix
    ./vscode.nix
    ./whatsapp.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
