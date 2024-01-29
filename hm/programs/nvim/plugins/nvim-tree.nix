{ pkgs, config, ... }:

{
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-tree-lua;
    type = "lua";
    config = ''
      local treeapi = require "nvim-tree.api"
      vim.keymap.set('n', '<leader>t', treeapi.tree.toggle)
      local function my_on_attach(bufnr)
        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
          }
        end

        treeapi.config.mappings.default_on_attach(bufnr)
      end

      require("nvim-tree").setup {
        on_attach = my_on_attach,
        filters = {
          dotfiles = true,
        },
      }
    '';
  }];
}
