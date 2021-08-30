  let g:clap_layout = {
    \ 'relative': 'editor',
    \ }
  let g:clap_preview_direction = 'UD'
  let g:clap_enable_icon = v:true
  let g:clap_layout = { 'relative': 'editor' }

  function! FinderHandler(cmd, opts) abort
    let opts = ""

    if get(a:opts, "cword") ==# v:true
      let cword = expand("<cword>")
      let opts = opts . " ++query=" . cword
    endif

    if get(a:opts, "vword") ==# v:true
      " not work
      let vword = GetVisualWordEscape()
      let opts = opts . " ++query=" . vword
    endif

    if get(a:opts, "buffer_dir") ==# v:true
      let buffer_dir = expand("%:p:h")
      let opts = opts . " +dir " . buffer_dir
    endif

    " let dir_path = get(g:, 'denite_cwd', getcwd())
    " let opts = ' ++query=' . cword

    echomsg opts
    execute 'Clap' a:cmd opts
  endfunction

  nnoremap <silent> <SPACE>fr <cmd>call FinderHandler("history", {})<CR>
  nnoremap <silent> <SPACE>ff <cmd>call FinderHandler("files", {})<CR>
  nnoremap <silent> <SPACE>fg <cmd>call FinderHandler("grep", {})<CR>
  xnoremap <silent> <SPACE>fg <cmd>call FinderHandler("grep", {"vword": v:true})<CR>
  nnoremap <silent> <SPACE>fG <cmd>call FinderHandler("grep", {"cword": v:true})<CR>

  nnoremap <silent> <SPACE>bf <cmd>call FinderHandler("files", {"buffer_dir": v:true})<CR>
  nnoremap <silent> <SPACE>bg <cmd>call FinderHandler("grep", {"buffer_dir": v:true})<CR>
  nnoremap <silent> <SPACE>bG <cmd>call FinderHandler("grep", {"buffer_dir": v:true, "cword": v:true})<CR>

  nnoremap <silent> <SPACE>pf <cmd>call FinderHandler("git_files", {})<CR>

  nnoremap <silent> <SPACE>bb <cmd>call FinderHandler("buffers", {})<CR>
  nnoremap <silent> <SPACE>fj <cmd>call FinderHandler("jumps", {})<CR>
  nnoremap <silent> <SPACE>fh <cmd>call FinderHandler("command_history", {})<CR>
  nnoremap <silent> <SPACE>fp <cmd>call FinderHandler("registers", {})<CR>

