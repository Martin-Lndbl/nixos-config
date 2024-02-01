{ pkgs, lib, config, ... }:

{
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-base16;
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
