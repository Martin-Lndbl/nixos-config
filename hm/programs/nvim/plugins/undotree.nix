{ pkgs, ... }:
let
  undotree = pkgs.vimUtils.buildVimPlugin rec {
    pname = "undotree";
    version = "eab459ab87dd249617b5f7187bb69e614a083047";
    src = pkgs.fetchFromGitHub {
      owner = "jiaoshijie";
      repo = pname;
      rev = version;
      sha256 = "sha256-FIYDyfkaIS9C16ClWKLMdpSPv/OrcOalVVsyFJBU2eI=";
    };
    dependencies = [ pkgs.vimPlugins.plenary-nvim ];
  };
in
{
  programs.neovim.plugins = [
    pkgs.vimPlugins.plenary-nvim
    {
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
    }
  ];
}
