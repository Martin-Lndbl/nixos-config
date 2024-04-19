{ pkgs, config, ... }:
{
  programs.neovim.plugins = [ pkgs.vimPlugins.vim-wakatime ];

  home.sessionVariables = {
    WAKATIME_HOME = "${config.xdg.dataHome}/wakatime";
  };

  xdg.dataFile."wakatime/.wakatime.cfg" = {
    enable = true;
    text = ''
      [settings]
      debug = false
      hidefilenames = false
      ignore =
          COMMIT_EDITMSG$
          PULLREQ_EDITMSG$
          MERGE_MSG$
          TAG_EDITMSG$
      api_key_vault_cmd = "cat ${config.sops.secrets.wakatime.path}"
    '';
  };
}
