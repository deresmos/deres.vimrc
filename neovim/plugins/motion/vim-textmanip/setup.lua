local map = vim.keymap

-- Duplicate lines
map.set('x', '<Space>d', '<Plug>(textmanip-duplicate-down)', { silent = true, noremap = false })
map.set('x', '<Space>D', '<Plug>(textmanip-duplicate-up)', { silent = true, noremap = false })

-- Move lines and characters
map.set('x', '<C-j>', '<Plug>(textmanip-move-down)', { silent = true, noremap = false })
map.set('x', '<C-k>', '<Plug>(textmanip-move-up)', { silent = true, noremap = false })
map.set('x', '<C-h>', '<Plug>(textmanip-move-left)', { silent = true, noremap = false })
map.set('x', '<C-l>', '<Plug>(textmanip-move-right)', { silent = true, noremap = false })
