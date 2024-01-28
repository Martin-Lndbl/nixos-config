" Set cwd to NERDTree root
let g:NERDTreeChDirMode = 2

" Keep current line centered
let g:NERDTreeAutoCenterThreshold = 1000

" Remove distrubing elements
let g:NERDTreeMinimalUI = 1

  " Hide ignored files
let g:NERDTreeRespectWildIgnore = 1

" Don't draw fancy arrows
let g:NERDTreeDirArrows = 0
let g:NERDTreeDirArrowExpandable="~"
let g:NERDTreeDirArrowCollapsible="+"

" autoread on filechange
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded."| echohl None

nnoremap ,k :NERDTreeFocus<CR>
nnoremap ,t :NERDTreeToggle<CR>

