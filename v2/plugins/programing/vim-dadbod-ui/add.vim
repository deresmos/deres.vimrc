function! s:customDBUIMapping() abort
  nmap <buffer> l <Plug>(DBUI_SelectLine)
  nmap <buffer> <C-M> <Plug>(DBUI_SelectLine)
  nmap <buffer> o <Plug>(DBUI_SelectLine)
endfunction

nmap <Space>dbw <Plug>(DBUI_SaveQuery)
nmap <Space>dbe <Plug>(DBUI_EditBindParameters)

augroup my-vim-dabod-ui
  autocmd!
  autocmd FileType dbui call <SID>customDBUIMapping()
augroup END
