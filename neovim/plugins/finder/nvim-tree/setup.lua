vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.keymap.set("n", "<Space>ft", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })
