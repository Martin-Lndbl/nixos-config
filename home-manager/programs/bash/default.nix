{ pkgs, config, lib, ... }:

with config.colorscheme.colors;
let

  R = builtins.substring 0 2 base05;
  G = builtins.substring 2 2 base05;
  B = builtins.substring 4 2 base05;
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
      "cfg" = "cd ~/.config/nixos-system-config";
      c = "clear";
      switch = "home-manager switch --flake ~/.config/nixos-system-config#mrtn@$(hostname)";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos-system-config#$(hostname)";
      rebuild-boot = "sudo nixos-rebuild boot --flake ~/.config/nixos-system-config#$(hostname)";
    };
  };
}
