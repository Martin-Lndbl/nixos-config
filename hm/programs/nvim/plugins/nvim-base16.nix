{ pkgs, lib, config, ... }:

{
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-base16;
    type = "lua";
    config = ''
      require('base16-colorscheme').setup({ ${builtins.foldl'
        (acc: new: "${acc}\n${new.name} = '#${new.value}',") ""
        (lib.attrsets.mapAttrsToList
          (name: value: { name = name; value = value; })
            config.colorscheme.colors)
        }
      })
    '';
  }];
}
