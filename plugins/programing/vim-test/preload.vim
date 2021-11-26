let g:test#strategy = 'dispatch'
let g:test#python#pytest#file_pattern = '.*'
let g:test#python#pytest#options = {
  \ 'all': '--tb=short -q -p no:sugar',
  \ }

let g:dispath_compilers = {'pytest': 'pytest'}

function! DapStrategy(cmd)
  echom 'It works! Command for running tests: ' . a:cmd
  let g:vim_test_last_command = a:cmd
  lua Dap.strategy()
endfunction

lua << EOF
Dap.vim_test_strategy = {
  go = function(cmd)
    local run_option = string.match(cmd, "-run '([^ ]+)'")
    local path = string.match(cmd, "[^ ]+$")
    path = string.gsub(path, "/%.%.%.", "")

    configuration = {
      type = "go",
      name = "nvim-dap strategy",
      request = "launch",
      mode = "test",
      program = path,
      args = {},
    }

    if run_option then
      table.insert(configuration.args, "-test.run")
      table.insert(configuration.args, run_option)
    end

    if path == nil or path == "." then
      configuration.program = "./"
    end

    return configuration
  end,
}

function Dap.strategy()
  local cmd = vim.g.vim_test_last_command
  local filetype = vim.bo.filetype
  local f = Dap.vim_test_strategy[filetype]

  if not f then
    print("This filetype is not supported.")
    return
  end

  configuration = f(cmd)
  require'dap'.run(configuration)
end

EOF

let g:test#custom_strategies = {'dap': function('DapStrategy')}
let g:test#strategy = 'dap'
