{ pkgs, ... }:

{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.base16-nvim;
      type = "lua";
      config = ''
        vim.opt.termguicolors = true
        local caelestia_path = vim.env.HOME .. "/.local/state/caelestia/theme/base16-nvim.lua"
        local ok, colors = pcall(dofile, caelestia_path)
        if not ok then
          colors = {
            base00 = '#181818', base01 = '#282828', base02 = '#383838', base03 = '#585858',
            base04 = '#b8b8b8', base05 = '#d8d8d8', base06 = '#e8e8e8', base07 = '#f8f8f8',
            base08 = '#ab4642', base09 = '#dc9656', base0A = '#f7ca88', base0B = '#a1b56c',
            base0C = '#86c1b9', base0D = '#7cafc2', base0E = '#ba8baf', base0F = '#a16946',
          }
        end
        require('base16-colorscheme').setup(colors)
      '';
    }
  ];
}
