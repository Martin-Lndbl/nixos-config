{ pkgs, ... }:

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

  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-treesitter;
    type = "lua";
    config = ''
      require'nvim-treesitter.configs'.setup{
      	ensure_installed = {},
      	highlight = {
      		enable = true,
      		additional_vim_regex_highlighting = true,
      	},
      }
      
      ${tsl [
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
      ]}
    '';
  }];

}
