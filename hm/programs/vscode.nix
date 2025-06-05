{ pkgs, ... }:

{
  programs.vscode =
    {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        james-yu.latex-workshop
        vscodevim.vim
        wakatime.vscode-wakatime
        donjayamanne.githistory
      ];
    };
}
