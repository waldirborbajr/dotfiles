"
" Installs Java CoC plugin (language server, autocomplete)
"
call add(g:coc_global_extensions, 'coc-pyright')

" identation pep8 python
au BufNewFile,BufRead *.py
    \ set tabstop=3
    \ set softtabstop=3
    \ set shiftwidth=3
    \ set textwidth=120
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix