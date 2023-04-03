require('git-conflict').setup({
  default_mappings = true,
  default_commands = true,
  disable_diagnostics = false,
  highlights = {
    incoming = 'DiffText',
    current = 'DiffAdd',
  }
})

vim.keymap.set('n', '<Space>gcj', '<cmd>GitConflictNextConflict<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gck', '<cmd>GitConflictPrevConflict<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gct', '<cmd>GitConflictChooseTheirs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gco', '<cmd>GitConflictChooseOurs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gcn', '<cmd>GitConflictChooseNone<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gcb', '<cmd>GitConflictChooseBase<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Space>gcB', '<cmd>GitConflictChooseBoth<CR>', { noremap = true, silent = true })
