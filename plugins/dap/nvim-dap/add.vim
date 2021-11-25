nmap <silent> <SPACE>mdc <cmd>lua require'dap'.continue()<CR>
nmap <silent> <SPACE>mdC <cmd>lua require'dap'.run_last()<CR>
nmap <silent> <SPACE>mdq <cmd>lua require'dap'.stop()<CR>
" nmap <silent> <SPACE>mdR <Plug>VimspectorRestart
" nmap <silent> <SPACE>mdc <Plug>VimspectorPause
nmap <silent> <SPACE>mdp <cmd>lua require'dap'.toggle_breakpoint()<CR>
nmap <silent> <SPACE>mdP <cmd>lua require'dap.breakpoints'.clear()<CR>
" nmap <silent> <SPACE>mdc <Plug>VimspectorAddFunctionBreakpoint
nmap <silent> <SPACE>mdn <cmd>lua require'dap'.step_over()<CR>
nmap <silent> <SPACE>mdi <cmd>lua require'dap'.step_into()<CR>
nmap <silent> <SPACE>mdo <cmd>lua require'dap'.step_out()<CR>
nmap <silent> <SPACE>mdb <cmd>lua require'dap'.step_back()<CR>

nmap <silent> <SPACE>mdu <cmd>lua require'dap'.up()<CR>
nmap <silent> <SPACE>mdd <cmd>lua require'dap'.down()<CR>

" nnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
" xnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>

" nnoremap <silent> <SPACE>mdf :<C-u>call <SID>run_file()<CR>
" nnoremap <silent> <SPACE>mdt :<C-u>call <SID>run_test()<CR>
" nnoremap <silent> <SPACE>mde :<C-u>call <SID>run_execute()<CR>

nnoremap <silent> <SPACE>mdQ <cmd>call <SID>dapTerminate()<CR>

nnoremap <silent> <SPACE>mdT <cmd>lua require'dapui'.toggle()<CR>
nnoremap <silent> <SPACE>mdf <cmd>call <SID>openFloatWin()<CR>

function! s:dapTerminate() abort
  lua require'dap'.terminate()
  lua require'dapui'.close()
  lua require'nvim-dap-virtual-text'.refresh()
  tabclose
endfunction

function! s:openFloatWin() abort
lua << EOF
  local filetype = vim.bo.filetype
  local name = filetype:gsub("dapui_", "")
  for i, value in ipairs({"scopes", "watches", "breakpoints", "stacks", "repl"}) do
    if name == value then
      require'dapui'.float_element(name, {enter=true})
      break
    end
  end
EOF
endfunction


lua << EOF
  local dap = require('dap')
  dap.listeners.before['event_initialized']['custom'] = function(session, body)
    vim.cmd('tabedit')
    require'dapui'.open()
  end

  dap.listeners.before['event_terminated']['custom'] = function(session, body)
    print('Session terminated')
    require'dapui'.close()
    require'nvim-dap-virtual-text'.refresh()
    vim.cmd('tabclose')
  end
EOF
