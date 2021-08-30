  let g:nvimterm#toggle_size = 30
  let g:nvimterm#enter_insert = 0

  function! s:terminal_keymap() abort
    nnoremap <buffer> I i<C-a>
    nnoremap <buffer> A a<C-e>
    nnoremap <buffer> dd i<C-e><C-u><C-\><C-n>
    nnoremap <buffer> cc i<C-e><C-u>
    nnoremap <buffer> q :<C-u>close<CR>
  endfunction

  augroup nvim-term-custom
    autocmd!
    autocmd FileType nvim-term,nvim-term-t call s:terminal_keymap()
  augroup END

  nnoremap <silent> <SPACE>ts :NTermS<CR>
  nnoremap <silent> <SPACE>tv :NTermV<CR>
  nnoremap <silent> <SPACE>tt :NTermT<CR>
  nnoremap <silent> <SPACE>to :NTermToggle<CR>
  nnoremap <silent> <SPACE>te :NTerm<CR>
