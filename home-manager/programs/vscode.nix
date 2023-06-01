{ pkgs, ... }:

{
  programs.vscode =
    {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        james-yu.latex-workshop
        /* WakaTime.vscode-wakatime */
      ];
    };
}
