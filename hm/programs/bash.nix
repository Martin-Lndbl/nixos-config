{ lib, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra =
      #bash
      ''
        export EDITOR="vim"
      '';
    shellAliases = {
      ".." = "cd ..";
      "..." = ".. && ..";
      "...." = "... && ..";
      "cfg" = "cd ~/.config/nixos-config";
      c = "clear";
      switch = lib.mkDefault "home-manager switch --flake ~/.config/nixos-config";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos-config";
      rebuild-boot = "sudo nixos-rebuild boot --flake ~/.config/nixos-config";

      osvbuild = "docker run -it -v ~/documents/uni/bsc-thesis/osv:/git-repos/host -w /git-repos/host --privileged osv/builder";
    };
  };
}
