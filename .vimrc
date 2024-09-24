if (empty($TMUX))
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme onedark
syntax on

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

set number
set relativenumber

set mouse=
set ttymouse=

inoremap <> <><esc>i
inoremap () ()<esc>i
inoremap [] []<esc>i
inoremap {} {}<esc>i
inoremap '' ''<esc>i
inoremap "" ""<esc>i

inoremap <c-f> <right>
inoremap <c-b> <left>
