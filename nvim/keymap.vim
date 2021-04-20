" use just one list of errors: quickfix
let g:go_list_type = "quickfix"

" 
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

let g:startify_session_dir = "~/.config/nvim/session"

let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25

let g:ctrlp_use_caching=0

" Abbreviations
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

map <F1> :colorscheme gruvbox<CR>
map <F2> :colorscheme onehalflight<CR>
map <F3> :set background=dark<CR>
map <F4> :set background=light<CR>

" navigate between errors
"map <C-n> :cnext<CR>
"map <C-m> :cprevious<CR>
"nnoremap <leader>a :cclose<CR>

" Shortcut to edit THIS configuration file: (e)dit (c)onfiguration
nnoremap <silent> <leader>se :e $MYVIMRC<CR>

" Shortcut to source (reload) THIS configuration file after editing it: (s)ource (c)onfiguraiton
nnoremap <silent> <leader>sc :source $MYVIMRC<CR>

" toggle line numbers
nnoremap <silent> <leader>n :set number! number?<CR>

" toggle line wrap
nnoremap <silent> <leader>w :set wrap! wrap?<CR>

" buffer (switch between current and last buffer)
nnoremap <silent> <leader>bb <C-^>
" go to next buffer
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <C-]> :bn<CR>
" go to previous buffer
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <C-[> :bp<CR>
" https://github.com/neovim/neovim/issues/2048
"nnoremap <C-h> :bp<CR>
" close buffer
nnoremap <silent> <leader>bd :bd<CR>
" nnoremap <C-\> :bd<CR>
" kill buffer
nnoremap <silent> <leader>bk :bd!<CR>
" list buffers
nnoremap <silent> <leader>bl :ls<CR>
" list and select buffer
nnoremap <silent> <leader>bg :ls<CR>:buffer<Space>
" horizontal split with new buffer
nnoremap <silent> <leader>bh :new<CR>
" vertical split with new buffer
nnoremap <silent> <leader>bv :vnew<CR>

" improved keyboard navigation
"nnoremap <leader>h <C-w>h
"nnoremap <leader>j <C-w>j
"nnoremap <leader>k <C-w>k
"nnoremap <leader>l <C-w>l

" Mover no modo insert sem as setas
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>
