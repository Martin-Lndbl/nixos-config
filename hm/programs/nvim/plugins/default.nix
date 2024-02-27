{ config, pkgs, lib, ... }:

{
  imports = [
    ./base16-nvim.nix # colorscheme
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
