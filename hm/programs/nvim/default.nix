{ pkgs, ... }:
{

  imports = [
    ./plugins
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    extraConfig = ''
      set relativenumber
      set autoindent
      set tabstop=2
      set shiftwidth=2 smarttab
      set expandtab
      set mouse=a

      set undofile
      set undodir=$HOME/.tmp/undo
      set undolevels=1000
      set undoreload=1000

      set spelllang=en,de,cjk
      set spell

      " Only works for lua config due to order HomeManager appends text
      let mapleader = ","
    '';

    extraPackages = with pkgs; [
      nodePackages.bash-language-server
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
    exec = "alacritty --command nvim %F";
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
