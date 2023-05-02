-- " nnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' expand('<cword>')<CR>
-- " xnoremap <silent> <SPACE>mdw :<C-u>execute 'VimspectorWatch' GetVisualWord()<CR>

local function openFloatWin()
  local filetype = vim.bo.filetype
  local name = filetype:gsub("dapui_", "")
  for i, value in ipairs({ "scopes", "watches", "breakpoints", "stacks", "repl" }) do
    if name == value then
      require 'dapui'.float_element(name, { enter = true })
      break
    end
  end
end

-- " nmap <silent> <SPACE>mdc <Plug>VimspectorPause
-- " nmap <silent> <SPACE>mdc <Plug>VimspectorAddFunctionBreakpoint

local dap = require('dap')
dap.listeners.before['event_initialized']['custom'] = function(session, body)
  vim.cmd('tabedit')
  require 'dapui'.open()
end

dap.listeners.before['event_terminated']['custom'] = function(session, body)
  print('Session terminated')
  require 'dapui'.close()
  require 'nvim-dap-virtual-text'.refresh()
  vim.cmd('tabclose')
end

Dap = {}

Dap.configuration = {
  go_file = {
    type = "go",
    name = "Debug file",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  go_test_file = {
    type = "go",
    name = "Debug test file",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  go_test = {
    type = "go",
    name = "Debug test suite",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  go_test_nearest = function()
    require 'dap-go'.debug_test()
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
    require 'dap'.run(configuration)
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

vim.keymap.set('n', '<Space>mdc', "<cmd>lua require'dap'.continue()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdC', "<cmd>lua require'dap'<cmd>lua require'dap'.run_last()<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdq', "<cmd>lua require'dap'.stop()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdR', "<Plug>VimspectorRestart", { silent = true, noremap = false })
vim.keymap.set('n', '<Space>mdp', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdP', "<cmd>lua require'dap.breakpoints'.clear()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdn', "<cmd>lua require'dap'.step_over()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdi', "<cmd>lua require'dap'.step_into()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdo', "<cmd>lua require'dap'.step_out()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdb', "<cmd>lua require'dap'.step_back()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdu', "<cmd>lua require'dap'.up()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdd', "<cmd>lua require'dap'.down()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdl', "<cmd>lua require'dap'.list_breakpoints()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdf', "<cmd>lua Dap.run_test_file()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdt', "<cmd>lua Dap.run_test()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdm', "<cmd>lua Dap.run_test_nearest()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdQ', "<cmd>lua require'dap'.terminate()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdT', "<cmd>lua require'dapui'.toggle()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mdF', openFloatWin, { silent = true, noremap = true })
