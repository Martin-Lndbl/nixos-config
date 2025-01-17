{ pkgs, ... }:
{
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.undotree;
    type = "lua";
    config = ''
      local undotree = require('undotree')
      vim.keymap.set('n', '<leader>u', undotree.toggle, { noremap = true, silent = true })

      undotree.setup({
        float_diff = true,
        layout = "left_bottom",
        position = "left",
        ignore_filetype = {
          'undotree',
          'undotreeDiff',
          'qf',
          'TelescopePrompt',
          'spectre_panel',
          'tsplayground',
        },
        window = {
          winblend = 30,
        },
        keymaps = {
          ['j'] = "move_next",
          ['k'] = "move_prev",
          ['gj'] = "move2parent",
          ['J'] = "move_change_next",
          ['K'] = "move_change_prev",
          ['<cr>'] = "action_enter",
          ['p'] = "enter_diffbuf",
          ['q'] = "quit",
        },
      })
    '';
  }];
}
