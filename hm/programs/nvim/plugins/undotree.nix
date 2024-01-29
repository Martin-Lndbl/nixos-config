{ pkgs, config, ... }:
let
  undotree = pkgs.vimUtils.buildVimPlugin rec {
    pname = "undotree";
    version = "80552a0180b49e5ba072c89ae91ce5d4e3aed36b";
    src = pkgs.fetchFromGitHub {
      owner = "jiaoshijie";
      repo = pname;
      rev = version;
      sha256 = "sha256-clxoKM5kusRz8OR5+Z+4NS0WsoMx9tdyi9GG+sE6r3s=";
    };
  };
in
{
  programs.neovim.plugins = [{
    plugin = undotree;
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
