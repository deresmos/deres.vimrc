let g:committia_open_only_vim_starting = 1
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info) abort
  nmap <buffer><C-j> <Plug>(committia-scroll-diff-down-half)
  nmap <buffer><C-k> <Plug>(committia-scroll-diff-up-half)
endfunction
