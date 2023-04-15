vim.g.startify_disable_at_vimenter = 1
vim.g.startify_files_number = 10
vim.g.startify_custom_indices = { 'a', 'b', 'c', 'd', 'f', 'g', 'i', 'm',
  'n', 'o', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'z' }
-- vim.g.startify_list_order = {
--    ['Bookmarks:'],
--    'bookmarks',
--    ['Recentry open files:'],
--    'files',
--    ['Recentry open files in dir:'],
--    'dir',
--    }

vim.g.startify_session_sort = 0
vim.g.startify_session_persistence = 0
vim.g.startify_session_savevars = {}

vim.g.startify_session_before_save = {
  'echo "Cleaning up before saving..."',
  'silent! call CloseUnloadedBuffers()',
  'silent! bd __XtermColorTable__',
}

vim.g.startify_custom_header = {
  "        _                                   _            ",
  "     __| |  ___  _ __   ___  ___    __   __(_) _ __ ___  ",
  "    / _` | / _ \\| '__| / _ \\/ __|   \\ \\ / /| || '_ ` _ \\ ",
  "   | (_| ||  __/| |   |  __/\\__ \\ _  \\ V / | || | | | | |",
  "    \\__,_| \\___||_|    \\___||___/(_)  \\_/  |_||_| |_| |_|",
}
vim.g.startify_change_to_dir = 1

vim.keymap.set('n', '<Space>ss', ':<C-u>SSave<Space>', { noremap = true })
vim.keymap.set('n', '<Space>sS', ':<cmd>SSave!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Space>sd', ':<C-u>SDelete<Space>', { noremap = true })
vim.keymap.set('n', '<Space>sc', ':<C-u>SClose<CR>:cd ~<CR>', {silent = true, noremap=true})
