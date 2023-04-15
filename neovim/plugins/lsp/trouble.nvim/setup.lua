local map = vim.keymap
map.set('n', '[Trouble]', '<Nop>', { noremap = true, silent = true })
map.set('n', '<space>l', '[Trouble]', { noremap = true, silent = true })

map.set('n', '[Trouble]w', '<cmd>TroubleToggle workspace_diagnostics<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]d', '<cmd>TroubleToggle document_diagnostics<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]q', '<cmd>TroubleToggle quickfix<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]l', '<cmd>TroubleToggle loclist<CR>', { noremap = true, silent = true })
map.set('n', '[Trouble]r', '<cmd>TroubleToggle lsp_references<CR>', { noremap = true, silent = true })
