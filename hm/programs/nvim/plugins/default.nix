{ config, pkgs, lib, ... }:

let

  tsl = languages: builtins.foldl'
    (
      acc: new:
        ''
          vim.treesitter.language.require_language("${new}", "${
            "${pkgs.tree-sitter.builtGrammars."tree-sitter-${new}"}/parser"
          }")${"\n\n"}${acc}
        ''
    ) ""
    languages;

in

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
      vim-commentary
      delimitMate
      vim-css-color
      BufOnly-vim
      vim-vsnip
    ];
}
