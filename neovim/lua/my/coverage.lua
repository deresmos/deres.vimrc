local M = {}

function M.load()
   vim.cmd("Coverage")
end

function M.toggle()
   vim.cmd("CoverageToggle")
end

function M.clear()
   vim.cmd("CoverageClear")
end

function M.summary()
   vim.cmd("CoverageSummary")
end

return M
