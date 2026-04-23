{ pkgs, ... }:

{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-tree-lua;
      type = "lua";
      config =
        #lua
        ''
          require("nvim-tree").setup()
          local nvimtreeapi = require("nvim-tree.api")
          vim.keymap.set("n", "<leader>t", nvimtreeapi.tree.toggle, { desc = "Toggle NvimTree" })
        '';
    }
  ];
}
