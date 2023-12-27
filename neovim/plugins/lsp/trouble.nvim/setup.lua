local function open_workspace_diagnostics()
  require('trouble').open('workspace_diagnostics')
end

local function open_quickfix(name)
  require('trouble').open('quickfix')
end


vim.keymap.set('n', '<Space>lw', open_workspace_diagnostics, { noremap = true, silent = true })
-- vim.keymap.set('n', '<Space>ld', '<cmd>Trouble document_diagnostics<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>lq', open_quickfix, { noremap = true, silent = true })
-- vim.keymap.set('n', '<Space>ll', '<cmd>Trouble loclist<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<Space>lr', '<cmd>Trouble lsp_references<CR>', { noremap = true, silent = true })
