function! s:dap_setup() abort
  nmap <silent><buffer> <SPACE>mdc <cmd>lua require'dap'.continue()<CR>
  nmap <silent><buffer> <SPACE>mdC <cmd>lua require'dap'.run_last()<CR>
  nmap <silent><buffer> <SPACE>mdq <cmd>lua require'dap'.stop()<CR>
  " nmap <silent><buffer> <SPACE>mdR <Plug>VimspectorRestart
  " nmap <silent><buffer> <SPACE>mdc <Plug>VimspectorPause
  nmap <silent><buffer> <SPACE>mdp <cmd>lua require'dap'.toggle_breakpoint()<CR>
  " nmap <silent><buffer> <SPACE>mdc <Plug>VimspectorAddFunctionBreakpoint
  nmap <silent><buffer> <SPACE>mdn <cmd>lua require'dap'.step_over()<CR>
  nmap <silent><buffer> <SPACE>mdi <cmd>lua require'dap'.step_into()<CR>
  nmap <silent><buffer> <SPACE>mdo <cmd>lua require'dap'.step_out()<CR>
  nmap <silent><buffer> <SPACE>mdb <cmd>lua require'dap'.step_back()<CR>

  nmap <silent><buffer> <SPACE>mdu <cmd>lua require'dap'.up()<CR>
  nmap <silent><buffer> <SPACE>mdd <cmd>lua require'dap'.down()<CR>

  " nnoremap <silent><buffer> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
  " xnoremap <silent><buffer> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>

  " nnoremap <silent><buffer> <SPACE>mdf :<C-u>call <SID>run_file()<CR>
  " nnoremap <silent><buffer> <SPACE>mdt :<C-u>call <SID>run_test()<CR>
  " nnoremap <silent><buffer> <SPACE>mde :<C-u>call <SID>run_execute()<CR>

  nnoremap <silent><buffer> <SPACE>mdQ <cmd>lua require'dap'.terminate()<CR>

  nnoremap <silent><buffer> <SPACE>mdT <cmd>lua require'dapui'.toggle()<CR>
endfunction

augroup custom_dap
  autocmd!
  autocmd FileType go,python call <SID>dap_setup()
augroup END
