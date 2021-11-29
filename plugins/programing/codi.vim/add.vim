function! s:Codi(...) abort
  let edit = 'tabedit'
  if a:0 > 1
    let edit = a:2
  endif

  execute edit '$HOME/.scratch.' . a:1
  execute 'Codi'
endfunction

command! -nargs=? CodiPython     call s:Codi('py',  <f-args>)
command! -nargs=? CodiJavaScript call s:Codi('js',  <f-args>)
command! -nargs=? CodiPHP        call s:Codi('php', <f-args>)

nnoremap <silent> <Space>mcip :CodiPython<CR>
nnoremap <silent> <Space>mcij :CodiJavaScript<CR>
nnoremap <silent> <Space>mcih :CodiPHP<CR>
