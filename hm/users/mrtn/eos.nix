{
  pkgs,
  ...
}:
{
  imports = [
    ../../programs/nvim
    ../../programs/bash.nix
  ];

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";
  home.sessionVariables = {
    TERM = "xterm";
  };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";

  home.stateVersion = "25.11";
}
