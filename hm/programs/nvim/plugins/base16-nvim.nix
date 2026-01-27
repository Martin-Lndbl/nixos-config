{
  pkgs,
  lib,
  config,
  ...
}:

{
  stylix.targets.neovim.enable = false;
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.base16-nvim;
      type = "lua";
      config = ''
        vim.opt.termguicolors = true
        require('base16-colorscheme').setup({
        ${
          lib.attrsets.foldlAttrs (
            acc: n: v:
            acc + "  ${n} = '#${v}',\n"
          ) "" config.stylix.generated.palette
        }})
      '';
    }
  ];
}
