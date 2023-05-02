vim.g.test_strategy = 'dispatch'
vim.g.test_python_pytest_file_pattern = '.*'
vim.g.test_python_pytest_options = {
  all = '--tb=short -q -p no:sugar',
}

vim.g.dispatch_compilers = { pytest = 'pytest' }

VimtestDap = {}
function DapStrategy(cmd)
  print('It works! Command for running tests: ' .. cmd)
  vim.g.vim_test_last_command = cmd
  VimtestDap.strategy(cmd)
end

VimtestDap.vim_test_strategy = {
  go = function(cmd)
    local test_func = string.match(cmd, "-run '([^ ]+)'")
    local path = string.match(cmd, "[^ ]+$")
    path = string.gsub(path, "/%.%.%.", "")

    local configuration = {
      type = "go",
      name = "nvim-dap strategy",
      request = "launch",
      mode = "test",
      program = path,
      args = {},
    }

    if test_func then
      table.insert(configuration.args, "-test.run")
      table.insert(configuration.args, test_func)
    end

    if path == nil or path == "." then
      configuration.program = "./"
    end

    return configuration
  end,
}

function VimtestDap.strategy(cmd)
  local filetype = vim.bo.filetype
  local f = VimtestDap.vim_test_strategy[filetype]

  if not f then
    print("This filetype is not supported.")
    return
  end

  configuration = f(cmd)
  require 'dap'.run(configuration)
end

vim.api.nvim_set_var("test#custom_strategies", {
  dap = DapStrategy,
})

vim.api.nvim_set_var("test#strategy", "dap")
