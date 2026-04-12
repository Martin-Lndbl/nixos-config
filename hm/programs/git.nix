{ pkgs, ... }:

{
  programs.git = {

    enable = true;
    lfs.enable = true;
    settings.user.name = "Martin-Lndbl";
    settings.user.email = "";
  };
}
