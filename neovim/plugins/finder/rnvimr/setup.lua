vim.g.rnvimr_presets = {
  { width = 0.900, height = 0.900 },
}

vim.api.nvim_set_keymap('n', '<Space>ra', '<cmd>RnvimrToggle<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<Space>rA', '<cmd>RangerWorkingDirectory<CR>', {noremap = true, silent = true})
