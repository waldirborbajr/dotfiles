" golang
" run :GoBuild or :GoTestCompile based on the go file
" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Open :GoDeclsDir with ctrl-g
" nmap <C-g> :GoDeclsDir<cr>
" imap <C-g> <esc>:<C-u>GoDeclsDir<cr>
function! GoTest()
  :GoTest
  :VimuxRunCommand "clear; go test -v ./..."
  :cclose
endfunction

" TODO fix testing funcs
function! GoTestFunc()
  :GoTest
  :VimuxRunCommand "clear; go test -v ./..."
  ":GoTestFunc
  ":VimuxRunCommand "clear; go test ./..."
  :cclose
endfunction

function! GoImportList()
  if !executable('gopkgs')
    return s:warn('ag is not found')
  endif
  call fzf#run(fzf#wrap({'source': 'gopkgs', 'sink': 'GoImport'}))
endfunction

function! GoImportAndWrite(pkg)
  :GoImport a:pkg
endfunction
command! -nargs=1 FzfSinkGoImportAndWrite GoImport <f-args>

augroup go
  autocmd!

  "let g:deoplete#enable_at_startup = 1

  autocmd FileType go nmap <leader><C-i> :call GoImportList()<CR>

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  autocmd FileType go nmap <F4>  :exec GoTest()<CR>

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  " auto-identify
  "let g:go_auto_type_info = 1
  " same ids hilights
  "let g:go_auto_sameids = 1

  " show referrers
  autocmd FileType go nmap <Leader>e <Plug>(go-referrers)

  " GoRename
  autocmd FileType go nmap <Leader><F6> <Plug>(go-rename)

  " GoImpl
  autocmd FileType go nmap <Leader><F4> :GoImpl<CR>

  " Debug
  "let g:go_debug = ['shell-commands', 'debugger-state', 'debugger-commands']
  let g:go_debug = ['debugger-state', 'debugger-commands']
augroup END

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

nnoremap <C-n> :cnext<CR>
nnoremap <C-v> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
 