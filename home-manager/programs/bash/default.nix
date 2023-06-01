{ pkgs }:

{
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
    "hm" = "cd ~/.config/home-manager";
    c = "clear";
    switch = "home-manager switch --flake ~/.config/home-manager#mrtn";
  };
}
