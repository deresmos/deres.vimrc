  function! s:precious()
    augroup my-precious
      autocmd!
      autocmd CursorMoved <buffer> :PreciousSwitch
    augroup END

    omap <buffer> ic <Plug>(textobj-precious-i)
    vmap <buffer> ic <Plug>(textobj-precious-i)
    nmap <buffer><silent> <Space>mcC <Plug>(precious-quickrun-op)ic
  endfunction

  augroup my-precious-cmd
    autocmd!
    autocmd FileType vue,toml call s:precious()
    autocmd BufEnter,BufWinEnter *.vue,*.toml call s:precious()
  augroup END
