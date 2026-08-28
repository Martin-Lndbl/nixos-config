{ pkgs, lib, ... }:
let
  # $HOME is expanded by vim and by the activation shell alike
  undodir = "$HOME/.tmp/undo";
in
{

  imports = [
    ./plugins
  ];

  # nvim writes no undo history at all when this is missing
  home.activation.nvimUndoDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${undodir}"
  '';

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;

    extraConfig = ''
      set relativenumber
      set autoindent
      set tabstop=2
      set shiftwidth=2 smarttab
      set expandtab
      set mouse=a

      set undofile
      set undodir=${undodir}
      set undolevels=1000
      set undoreload=1000

      set spelllang=en,de,cjk
      set spell

      " Only works for lua config due to order HomeManager appends text
      let mapleader = ","
    '';

    extraPackages = with pkgs; [
      bash-language-server
      nixd
      pkgs.nixfmt
      lua-language-server
      texlab
    ];
  };

  xdg.desktopEntries.neovim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Edit text files";
    exec = "ghostty -e nvim %F";
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
      "TextEditor"
    ];
  };
}
