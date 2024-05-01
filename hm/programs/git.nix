{ pkgs, ... }:

{
  programs.git = {

    enable = true;
    lfs.enable = true;
    userEmail = "lblsolutions@outlook.de";
  };
}
