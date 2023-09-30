local dap = require('dap')

local M = {}

function M.continue()
   dap.continue()
end

function M.step_over()
   dap.step_over()
end

function M.step_into()
   dap.step_into()
end

function M.step_out()
   dap.step_out()
end

function M.step_back()
   dap.step_back()
end

function M.up()
   dap.up()
end

function M.down()
   dap.down()
end

function M.stop()
   dap.stop()
end

function M.terminate()
   dap.terminate()
end

function M.toggle_breakpoint()
   dap.toggle_breakpoint()
end

return M
