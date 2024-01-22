{ pkgs, config, ... }:

let
  spacecamp = pkgs.vimUtils.buildVimPlugin rec {
    pname = "spacecamp";
    version = "efe16a90234ae4c7714412d16f36af34284af321";
    src = pkgs.fetchFromGitHub {
      owner = "Martin-Lndbl";
      repo = pname;
      rev = version;
      sha256 = "sha256-I/oeZ+07KjMR8rqGk2+D7XeINk8bOP0quOSsuoatMLY=";
    };
  };

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

in

{
  programs.neovim = {
    baseConfiguration.enable = true;
    plugins = [
      base16_build
    ];

    extraConfig = ''
      set spelllang=en_us
      set spell
    '';
  };
}
