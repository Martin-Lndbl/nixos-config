{ pkgs, ... }:

{
  imports = [
    ./lsp.nix
    ./lualine.nix
    ./treesitter.nix
    ./nvim-tree.nix
    ./undotree.nix
    ./telescope.nix
    ./jdtls-nvim.nix
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    delimitMate
    vim-css-color
    BufOnly-vim
    vim-vsnip

    {
      plugin = comment-nvim;
      type = "lua";
      config =
        #lua
        ''
          require('Comment').setup()
          vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
        '';
    }
  ];
}
