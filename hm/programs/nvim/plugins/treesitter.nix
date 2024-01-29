{ pkgs, ... }:

{

  programs.neovim.plugins = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    bash
    c
    cpp
    c_sharp
    css
    html
    java
    javascript
    json
    lua
    make
    markdown
    r
    rust
    scss
    toml
    vimdoc
    yaml
    nix
    {
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
      '';
    }
  ];
}
