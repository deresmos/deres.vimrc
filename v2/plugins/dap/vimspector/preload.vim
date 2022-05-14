let g:vimspector_enable_mappings = 'HUMAN'

sign define vimspectorBP text=-> texthl=Error
sign define vimspectorPC text==> texthl=Normal
sign define vimspectorBPDisabled text=- texthl=Normal

function! s:run_file()
  call vimspector#LaunchWithSettings({'configuration': &filetype.'_file'})
endfunction

function! s:run_test()
  call vimspector#LaunchWithSettings({'configuration': &filetype.'_test'})
endfunction

function! s:run_execute()
  call vimspector#LaunchWithSettings({'configuration': &filetype.'_execute'})
endfunction

function! s:vimspector() abort
  nmap <silent><buffer> <SPACE>mdc <Plug>VimspectorContinue
  nmap <silent><buffer> <SPACE>mdq <Plug>VimspectorStop
  nmap <silent><buffer> <SPACE>mdR <Plug>VimspectorRestart
  " nmap <silent><buffer> <SPACE>mdc <Plug>VimspectorPause
  nmap <silent><buffer> <SPACE>mdp <Plug>VimspectorToggleBreakpoint
  " nmap <silent><buffer> <SPACE>mdc <Plug>VimspectorAddFunctionBreakpoint
  nmap <silent><buffer> <SPACE>mdn <Plug>VimspectorStepOver
  nmap <silent><buffer> <SPACE>mdi <Plug>VimspectorStepInto
  nmap <silent><buffer> <SPACE>mdo <Plug>VimspectorStepOut

  nmap <silent><buffer> <SPACE>mdu <Plug>VimspectorUpFrame
  nmap <silent><buffer> <SPACE>mdd <Plug>VimspectorDownFrame

  nnoremap <silent><buffer> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
  xnoremap <silent><buffer> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>

  nnoremap <silent><buffer> <SPACE>mdf :<C-u>call <SID>run_file()<CR>
  nnoremap <silent><buffer> <SPACE>mdt :<C-u>call <SID>run_test()<CR>
  nnoremap <silent><buffer> <SPACE>mde :<C-u>call <SID>run_execute()<CR>

  nnoremap <silent> <SPACE>mdQ :<C-u>call vimspector#Reset()<CR>
endfunction

augroup custom_vimspector_mapper
  autocmd!
  autocmd FileType python,sh,javascript,go call <SID>vimspector()
augroup END
