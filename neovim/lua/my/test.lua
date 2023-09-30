local M = {}

function M.run_nearest()
   vim.cmd("TestNearest")
end

function M.run_file()
   vim.cmd("TestFile")
end

function M.run_last()
   vim.cmd("TestLast")
end

function M.suite()
   vim.cmd("TestSuite")
end

function M.debug_mode()
   vim.notify("Vimtest DAP mode")
   vim.api.nvim_set_var("test#strategy", "dap")
end

function M.normal_mode()
   vim.notify("Vimtest normal mode")
   vim.api.nvim_set_var("test#strategy", "neovim")
end

function M.overseer_mode()
   vim.notify("Overseer normal mode")
   vim.api.nvim_set_var("test#strategy", "overseer")
end

return M
