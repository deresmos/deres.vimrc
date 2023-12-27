vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local function toggle()
  require("nvim-tree.api").tree.toggle { path = vim.fn.getcwd() }
end

vim.keymap.set("n", "<Space>ft", toggle, { silent = true, noremap = true })
