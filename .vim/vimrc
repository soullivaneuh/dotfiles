set encoding=utf-8 " Because nobody wants latin-1
set backspace=indent,eol,start
set mouse=a " Enable mouse
set relativenumber
set number " Show line numbers
set cursorline " Show on what line the cursor is
set ruler " Show line and column numbers of cursor position
set autoindent
set smartindent

" Needs +clipboard and +xterm_clipboard options to work
" @see https://stackoverflow.com/a/4608206/1731473
" @see https://www.slothparadise.com/copy-system-clipboard-vim/
vmap <C-C> "+y

" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug '~/.zplug/repos/junegunn/fzf'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
call plug#end()

" itchyny/lightline
set laststatus=2
set noshowmode " Mode is already shown by the plugin
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ }

" Theme setup
syntax enable
colorscheme solarized
let g:solarized_termtrans=1
set background=dark " Must be set after g:solarized_termtrans to make it working on some highlight
highlight SignColumn	cterm=none ctermbg=none
highlight LineNr	ctermbg=none
highlight CursorLineNr	ctermfg=3
highlight DiffAdd	ctermbg=none
highlight DiffDelete	ctermbg=none
highlight DiffChange	ctermbg=none
