{ lib, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra =
      #bash
      ''
        export EDITOR="vim"
        export PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] ";
        PROMPT_COMMAND='[ "''${_first_prompt:-}" ] && echo; _first_prompt=1'

        , () {
          local prog="''$1"
          shift
          nix shell "nixpkgs#''$prog" -c "''$prog" "''$@"
        }
      '';
    shellAliases = {
      "l" = "ls -la --color";
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
