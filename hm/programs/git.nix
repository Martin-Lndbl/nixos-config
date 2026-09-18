{ lib, ... }:

{
  programs.git = {

    enable = true;
    lfs.enable = true;
    # machines override this to tag their commits, see users/mrtn/cronus.nix
    settings.user.name = lib.mkDefault "Martin-Lndbl";
    settings.user.email = "lblsolutions@outlook.com";
    # keeps ~/.git-credentials working; it was only ever set in ~/.gitconfig
    settings.credential.helper = "store";
  };
}
