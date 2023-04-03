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
nmap <silent> <SPACE>mdl <cmd>lua require'dap'.list_breakpoints()<CR>

" nnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
" xnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>

nnoremap <silent> <SPACE>mdf <cmd>lua Dap.run_file()<CR>
nnoremap <silent> <SPACE>mdt <cmd>lua Dap.run_test()<CR>
nnoremap <silent> <SPACE>mdm <cmd>lua Dap.run_test_nearest()<CR>

nnoremap <silent> <SPACE>mdQ <cmd>lua require'dap'.terminate()<CR>

nnoremap <silent> <SPACE>mdT <cmd>lua require'dapui'.toggle()<CR>
nnoremap <silent> <SPACE>mdF <cmd>call <SID>openFloatWin()<CR>

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

  Dap = {}

  Dap.configuration = {
    go_file={
      type = "go",
      name = "Debug file",
      request = "launch",
      program = "${file}",
    },
    go_test_file={
      type = "go",
      name = "Debug test file",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    go_test={
      type = "go",
      name = "Debug test suite",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
    go_test_nearest = function()
      require'dap-go'.debug_test()
    end,
  }

  function Dap.run(run_type)
    local filetype = vim.bo.filetype
    local configuration = Dap.configuration[filetype .. "_" .. run_type]
    if not configuration then
      print("This filetype is not supported.")
      return
    end

    if type(configuration) == 'function' then
      configuration()
    else
      require'dap'.run(configuration)
    end
  end

  function Dap.run_file()
    Dap.run("file")
  end

  function Dap.run_test()
    Dap.run("test")
  end

  function Dap.run_test_file()
    Dap.run("test_file")
  end

  function Dap.run_test_nearest()
    Dap.run("test_nearest")
  end
EOF
