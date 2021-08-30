  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeAutoDeleteBuffer = 1
  let g:NERDTreeMapActivateNode = 'l'
  let g:NERDTreeMapChangeRoot = 'L'
  let g:NERDTreeMapUpdir = 'h'
  let g:NERDTreeMapUpdirKeepOpen = 'H'
  let g:NERDTreeMapOpenSplit = 's'
  let g:NERDTreeMapOpenVSplit = 'v'
  let g:NERDTreeMapOpenExpl = '<Nop>'
  augroup nerdtree-keymap
    autocmd!
    autocmd FileType nerdtree nmap <buffer> dd md
    autocmd FileType nerdtree nmap <buffer> DD mdy
    autocmd FileType nerdtree nmap <buffer> o ma
    autocmd FileType nerdtree nmap <buffer> i ml
    autocmd FileType nerdtree nmap <buffer> cp mc
    autocmd FileType nerdtree nmap <buffer> rn mm
    autocmd FileType nerdtree nmap <buffer> vd mv
  augroup END

  augroup nerdtree
    autocmd!
    autocmd VimLeavePre * NERDTreeClose
    " autocmd User Startified NERDTree
  augroup END

