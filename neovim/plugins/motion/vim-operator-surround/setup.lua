vim.keymap.set('n', 's', '<Nop>', {noremap=false})
vim.keymap.set('x', 's', '<Nop>', {noremap=false})

vim.keymap.set('n', 'sa', '<Plug>(operator-surround-append)', {silent=true, noremap=false})
vim.keymap.set('n', 'sd', '<Plug>(operator-surround-delete)', {silent=true, noremap=false})
vim.keymap.set('n', 'sr', '<Plug>(operator-surround-replace)', {silent=true, noremap=false})
