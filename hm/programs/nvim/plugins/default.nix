{ config, pkgs, lib, ... }:

{
  imports = [
    ./nvim-base16.nix # colorscheme
    ./lsp.nix # language server + auto-completion
    ./treesitter.nix
    ./nvim-tree.nix
    ./undotree.nix
    ./telescope.nix
  ];

  programs.neovim.plugins = with pkgs.vimPlugins;
    [
      delimitMate
      vim-css-color
      BufOnly-vim
      vim-vsnip
      {
        plugin = comment-nvim;
        type = "lua";
        config = "require('Comment').setup()";
      }
    ];
}
