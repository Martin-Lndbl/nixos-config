{ pkgs, lib, config, ... }:

{
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.base16-nvim;
    type = "lua";
    config = ''
      require('base16-colorscheme').setup({
      ${lib.attrsets.foldlAttrs
        (acc: n: v: acc + "  ${n} = '#${v}',\n") ""
            config.colorscheme.palette
      }})
    '';
  }];
}
