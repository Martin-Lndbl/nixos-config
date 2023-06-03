{ pkgs, config, ... }:

{
  programs.bash = {
    enable = true;
    bashrcExtra =
      ''
        export EDITOR="vim"
        PS1="\[\e[1;32m\][\t]: \w $\[\e[m\] "
      '';
    shellAliases = {
      ".." = "cd ..";
      "..." = ".. && ..";
      "...." = "... && ..";
      "cfg" = "cd ~/.config/nixos-system-config";
      c = "clear";
      switch = "home-manager switch --flake ~/.config/nixos-system-config#mrtn";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos-system-config#$(hostname)";
    };
  };
}
