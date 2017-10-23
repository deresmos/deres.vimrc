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

  autocmd FileType aspvbs if filereadable(expand('~/.vim/dict/nasp.dict')) |
    \ setlocal dictionary=~/.vim/dict/nasp.dict | endif

  autocmd FileType html,xhtml,css,aspvbs,wsh setlocal foldmethod=manual
  autocmd FileType html,xhtml,css,aspvbs,wsh nnoremap <buffer> <SPACE>vf zf
  autocmd FileType html,xhtml,css,aspvbs,wsh xnoremap <buffer> <SPACE>vf zf

  autocmd FileType wsh,vb UltiSnipsAddFiletypes aspvbs

  autocmd BufNewFile *.asp,*.vbs,*.wsf setlocal fileformat=dos
  autocmd BufNewFile *.asp,*.vbs,*.wsf setlocal fileencoding=sjis
  autocmd BufNewFile *.asp,*.vbs,*.wsf setlocal tabstop=4 shiftwidth=4

  autocmd FileType html,xhtml,css,aspvbs,wsh,vb,sql if
    \ &fileencoding ==# 'sjis' |
    \ setlocal tabstop=4 shiftwidth=4 | endif
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
