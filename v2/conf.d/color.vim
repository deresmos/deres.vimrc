function! s:my_highlights()
  highlight! link Folded Normal
endfunction

call s:my_highlights()
augroup my_highlight
  autocmd!
  autocmd ColorScheme * call s:my_highlights()
augroup END
