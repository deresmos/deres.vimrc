augroup custom-filetype
  autocmd!

  autocmd FileType help setlocal nobuflisted

  autocmd FileType qf,help,qfreplace,diff nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType qf nnoremap <silent><buffer>dd :call <SID>delEntry()<CR>
  autocmd FileType qf xnoremap <silent><buffer>d :call <SID>delEntry()<CR>
  autocmd FileType qf nnoremap <silent><buffer>u :call <SID>undoEntry()<CR>

  autocmd FileType agit_diff,diff setlocal nofoldenable
  autocmd FileType agit_diff,diff setlocal wrap

  autocmd FileType sql if filereadable(expand('~/.vim/dict/sql.dict')) |
    \ setlocal dictionary=~/.vim/dict/sql.dict | endif

  autocmd FileType html,xhtml set foldmethod=manual
  autocmd FileType html,xhtml nnoremap <buffer> <SPACE>vf zf
  autocmd FileType html,xhtml xnoremap <buffer> <SPACE>vf zf
augroup END

"functions {{{1
function! s:delEntry() range "{{{2
  let l:qf = getqflist()
  let l:history = get(w:, 'qf_history', [])
  call add(l:history, copy(l:qf))
  let w:qf_history = l:history
  unlet! l:qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(l:qf, 'r')
  execute a:firstline
endfunction

function! s:undoEntry() "{{{2
  let l:history = get(w:, 'qf_history', [])
  if !empty(l:history)
    call setqflist(remove(l:history, -1), 'r')
  endif
endfunction

" }}}1
