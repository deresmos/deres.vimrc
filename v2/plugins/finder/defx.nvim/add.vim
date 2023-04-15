nnoremap <silent> <SPACE>ft <cmd>Defx -buffer-name=defx-tree<CR>
nnoremap <silent> <SPACE>fT <cmd>Defx -buffer-name=defx-floating<CR>
nnoremap <silent> <SPACE>fo <cmd>call <SID>open_two_defx()<CR>

function! s:open_two_defx() abort
  tabedit
  execute 'Defx -new -winwidth=' . &columns/2
  execute 'Defx -new -winwidth=' . &columns/2
endfunction
