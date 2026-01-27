{ pkgs, ... }:

{

  programs.neovim.plugins = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    {
      plugin = pkgs.vimPlugins.nvim-treesitter;
      type = "lua";
    }
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
  ];
}
