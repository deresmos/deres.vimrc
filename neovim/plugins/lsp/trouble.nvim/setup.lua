local map = vim.keymap
map.set('n', '<Space>lw', '<cmd>Trouble workspace_diagnostics<CR>', { noremap = true, silent = true })
map.set('n', '<Space>ld', '<cmd>Trouble document_diagnostics<CR>', { noremap = true, silent = true })
map.set('n', '<Space>lq', '<cmd>Trouble quickfix<CR>', { noremap = true, silent = true })
map.set('n', '<Space>ll', '<cmd>Trouble loclist<CR>', { noremap = true, silent = true })
map.set('n', '<Space>lr', '<cmd>Trouble lsp_references<CR>', { noremap = true, silent = true })
