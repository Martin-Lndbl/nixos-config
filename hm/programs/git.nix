{ pkgs, ... }:

{
  programs.git = {

    enable = true;
    lfs.enable = true;
    settings.user.email = "";
  };
}
