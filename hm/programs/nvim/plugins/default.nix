{ config, pkgs, ... }:

let

  base16_build = {
    plugin = pkgs.vimPlugins.nvim-base16;
    type = "lua";
    config = with config.colorscheme.colors; "
        require('base16-colorscheme').setup({
          base00 = '#${base00}',
            base01 = '#${base01}',
            base02 = '#${base02}',
            base03 = '#${base03}',
            base04 = '#${base04}',
            base05 = '#${base05}',
            base06 = '#${base06}',
            base07 = '#${base07}',
            base08 = '#${base08}',
            base09 = '#${base09}',
            base0A = '#${base0A}',
            base0B = '#${base0B}',
            base0C = '#${base0C}',
            base0D = '#${base0D}',
            base0E = '#${base0E}',
            base0F = '#${base0F}',
          })";
  };

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
  programs.neovim.plugins = with pkgs.vimPlugins; [
    base16_build
    vim-commentary
    delimitMate
    vim-css-color
    BufOnly-vim

    vim-vsnip
    cmp-vsnip

    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = builtins.readFile ./lsp-config.lua;
    }
    {
      plugin = lsp_signature-nvim;
      type = "lua";
      config = builtins.readFile ./lsp-signature.lua;
    }
    cmp-nvim-lsp
    cmp-path
    cmp-buffer
    {
      plugin = nvim-cmp;
      type = "lua";
      config = builtins.readFile ./nvim-cmp.lua;
    }
    {
      plugin = nerdtree;
      config = builtins.readFile ./nerdtree.vim;
    }
    {
      plugin = undotree;
      config = builtins.readFile ./undotree.vim;
    }
    {
      plugin = telescope-nvim;
      type = "lua";
      config = builtins.readFile ./telescope.lua;
    }
    {
      plugin = nvim-treesitter;
      type = "lua";
      config = builtins.readFile ./treesitter.lua +
        tsl [
          "c"
          "cpp"
          "css"
          "graphql"
          "html"
          "java"
          "javascript"
          "json"
          "lua"
          "make"
          "markdown"
          "nix"
          "r"
          "toml"
          "yaml"
        ];
    }
  ];
}
