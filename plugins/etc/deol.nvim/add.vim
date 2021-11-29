  function! s:setup_deol() abort
    nnoremap <buffer> I i<C-a>
    nnoremap <buffer> A a<C-e>
    nnoremap <buffer> dd i<C-e><C-u><C-\><C-n>
    nnoremap <buffer> cc i<C-e><C-u>
  endfunction

  augroup deol-custom
    autocmd!
    autocmd FileType deol call s:setup_deol()
  augroup END

  " nnoremap <silent> <SPACE>tf :<C-u>call <SID>deol_floating()<CR>
  " nnoremap <silent> <SPACE>ts :<C-u>call <SID>deol_split()<CR>
  " nnoremap <silent> <SPACE>tv :<C-u>call <SID>deol_vsplit()<CR>
  " nnoremap <silent> <SPACE>tt :<C-u>call <SID>deol_tab()<CR>
  " nnoremap <silent> <SPACE>to :<C-u>call <SID>deol_bottom()<CR>
  " nnoremap <silent> <SPACE>te :<C-u>Deol<CR>

  function! s:deol_floating() abort
    exec 'Deol -split=floating'
      \ '-winrow=1 -winheight=' . string(&lines * 0.8)
      \ '-wincol=1 -winwidth=' . string(&columns)
  endfunction

  function! s:deol_split() abort
    new | Deol
  endfunction

  function! s:deol_vsplit() abort
    vnew | Deol
  endfunction

  function! s:deol_tab() abort
    tabnew | Deol
  endfunction

  function! s:deol_bottom() abort
    botright split | Deol
  endfunction
