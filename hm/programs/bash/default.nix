{ pkgs, config, lib, ... }:

with config.colorscheme.palette;
let

  R = builtins.substring 0 2 base0B;
  G = builtins.substring 2 2 base0B;
  B = builtins.substring 4 2 base0B;
in
#TODO: Clean up PS1 as soon as this issue is implemented: https://github.com/NixOS/nix/issues/7578
{
  programs.bash = {
    enable = true;
    bashrcExtra =
      ''
        export EDITOR="vim"
        PS1="\[\e[1m\e[38;2;$((16#${R}));$((16#${G}));$((16#${B}))m\][\u@\h:\w]$ \[\e[0m\]"
      '';
    shellAliases = {
      ".." = "cd ..";
      "..." = ".. && ..";
      "...." = "... && ..";
      "cfg" = "cd ~/.config/nixos-config";
      c = "clear";
      switch = lib.mkDefault "home-manager switch --flake ~/.config/nixos-config#mrtn@$(hostname)";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos-config#$(hostname)";
      rebuild-boot = "sudo nixos-rebuild boot --flake ~/.config/nixos-config#$(hostname)";

      osvbuild = "docker run -it -v ~/documents/uni/bsc-thesis/osv:/git-repos/host -w /git-repos/host --privileged osv/builder";
        };
    };
  }
