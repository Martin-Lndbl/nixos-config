{
  pkgs,
  ...
}:
{
  imports = [
    ../../common.nix
    ../../programs/nvim
    ../../programs/bash.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home.username = "ubuntu";
  home.homeDirectory = "/home/ubuntu";
  home.sessionVariables = {
    TERM = "xterm";
  };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";

  home.stateVersion = "25.11";
}
