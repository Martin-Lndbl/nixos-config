{ inputs, pkgs, lib, config, ... }:
{

  imports = [
    ./plugins
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    extraConfig = ''
      set number
      set autoindent
      set tabstop=2
      set shiftwidth=2 smarttab
      set expandtab
      set mouse=a

      set undofile
      set undodir=$HOME/.tmp/undo
      set undolevels=1000
      set undoreload=1000

      set spelllang=en_us
      set spell

      " Only works for lua config due to order HomeManager appends text
      let mapleader = ","
    '';

    extraLuaConfig = ''
      local function status_line()
        local file_name = "%-.16t"
        local modified = " %-m"
        local file_type = " %y"
        local right_align = "%="
        local line_no = "%10([%l/%L%)]"
        local pct_thru_file = "%5p%%"

        return string.format(
          "%s%s%s%s%s%s",
          file_name,
          modified,
          file_type,
          right_align,
          line_no,
          pct_thru_file
        )
      end

      vim.opt.statusline = status_line()
    '';

    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      sumneko-lua-language-server
      rnix-lsp
      texlab
    ];
  };

  xdg.desktopEntries.neovim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Edit text files";
    exec = "nvim %F";
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
    terminal = true;
    type = "Application";
    categories = [ "Utility" "TextEditor" ];
  };
}
