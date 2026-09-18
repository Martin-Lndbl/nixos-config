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

  home.username = "mrtn";
  home.homeDirectory = "/home/mrtn";
  home.sessionVariables = {
    TERM = "xterm";
  };
  home.packages = with pkgs; [ claude-code ];
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.bash.bashrcExtra = "source ~/.profile";

  home.stateVersion = "25.11";
}
