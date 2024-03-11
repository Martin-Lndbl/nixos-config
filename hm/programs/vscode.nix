{ pkgs, ... }:

{
  programs.vscode =
    {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        james-yu.latex-workshop
        vscodevim.vim
        /* WakaTime.vscode-wakatime */
      ];
    };
}
