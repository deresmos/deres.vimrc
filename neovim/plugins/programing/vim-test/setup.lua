vim.g.test_strategy = 'dispatch'
vim.g.test_python_pytest_file_pattern = '.*'
vim.g.test_python_pytest_options = {
  all = '--tb=short -q -p no:sugar',
}

vim.g.dispatch_compilers = { pytest = 'pytest' }

VimtestDap = {}
function DapStrategy(cmd)
  vim.notify('It works! Command for running tests: ' .. cmd)
  vim.g.vim_test_last_command = cmd

  VimtestDap.strategy(cmd)
end

function OverseerStrategy(cmd)
  local args = {}
  for match in string.gmatch(cmd, "[^ ]+") do
    table.insert(args, string.match(match, "[^'].*[^']"))
  end

  local path = string.match(cmd, "[^ ]+$")
  path = string.gsub(path, "/%.%.%.", "")

  local workspace_path, _ = require("project_nvim.project").get_project_root()

  local task = require('overseer').new_task({
    cmd = args,
    cwd = workspace_path,
    components = { { 'on_output_quickfix', open = false, relative_file_root = path }, 'default' }
  })
  task:start()
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

  local configuration = f(cmd)
  require 'dap'.run(configuration)
end

vim.api.nvim_set_var("test#custom_strategies", {
  dap = DapStrategy,
  overseer = OverseerStrategy,
})

vim.api.nvim_set_var("test#go#gotest#options", "-v -coverprofile=cover.out")
vim.api.nvim_set_var("test#strategy", "overseer")
