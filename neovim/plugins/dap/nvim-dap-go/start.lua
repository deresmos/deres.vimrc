require('dap-go').setup()

local dap = require('dap')
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug file",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test suite",
    request = "launch",
    mode = "test",
    program = "${workspaceFolder}",
  }
}
