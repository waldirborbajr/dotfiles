syntax enable
syntax on
set showcmd			" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden			" Hide buffers when they are abandoned
set termguicolors
set nocompatible
set vb t_vb=
set hlsearch
set nonumber
set nowrap
set ruler
set noshowmode
set laststatus=2
set cursorline
set sidescroll=6
set scrolloff=9
set hidden
set confirm
set autowriteall
set wildmenu wildmode=full
set undodir=$HOME/.config/nvim/undodir
set undofile
set nobackup
set nowritebackup
set hidden
set cmdheight=2
set updatetime=150
set shortmess+=c
set colorcolumn=120
set splitright
set splitbelow
set tabstop=3
set shiftwidth=3
set expandtab
set signcolumn=yes

set mouse=a

set ttyfast                     " Indicate fast terminal conn for faster redraw

"set shell=zsh

highlight ColorColumn ctermbg=0 guibg=lightgrey
filetype on
filetype plugin on
filetype indent on

" change the leader key from "\" to ";" ("," is also popular)
let mapleader=" "

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']