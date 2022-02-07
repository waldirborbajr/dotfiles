Plug 'arcticicestudio/nord-vim'

augroup NordOverrides
    autocmd!
    autocmd ColorScheme nord highlight NordBoundary guibg=none
    autocmd ColorScheme nord highlight NordDiffDelete ctermbg=none guibg=none
    autocmd ColorScheme nord highlight NordComment cterm=italic gui=italic
    autocmd User PlugLoaded ++nested colorscheme nord
augroup end
