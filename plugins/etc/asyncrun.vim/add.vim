  function! s:asyncrun_after()
    let defualt_cmd = 'copen | wincmd p'
    let cmd = get(b:, 'asyncrun_after_cmd', v:null)
    if cmd == v:null
      let cmd = defualt_cmd
    endif

    execute cmd

    " Reset asyncrun_after_cmd
    if exists('b:asyncrun_after_cmd')
      unlet b:asyncrun_after_cmd
    endif
  endfunction

  augroup custom-asyncrun
    autocmd!
    autocmd User AsyncRunStart highlight! LightlineMiddle_active ctermbg=34
    autocmd User AsyncRunStop highlight! link LightlineMiddle_active LightlineMiddle_normal | call s:asyncrun_after()
  augroup END
