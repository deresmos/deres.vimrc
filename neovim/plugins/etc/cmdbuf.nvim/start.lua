vim.keymap.set("n", "<Space>q:", function()
  require("cmdbuf").split_open(20, { type = "vim/cmd" })
end)
vim.keymap.set("n", "<Space>ql", function()
  require("cmdbuf").split_open(20, { type = "lua/cmd" })
end)
vim.keymap.set("n", "<Space>q/", function()
  require("cmdbuf").split_open(20, { type = "vim/search/forward" })
end)
vim.keymap.set("n", "<Space>q?", function()
  require("cmdbuf").split_open(20, { type = "vim/search/backward" })
end)

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("cmdbuf-setting", {}),
  pattern = { "CmdbufNew" },
  callback = function()
    vim.bo.bufhidden = "wipe"
    vim.keymap.set("n", "q", [[<Cmd>quit<CR>]], { nowait = true, buffer = true })
    -- vim.keymap.set("n", "dd", [[<Cmd>lua require('cmdbuf').delete()<CR>]], { buffer = true })
  end,
})
