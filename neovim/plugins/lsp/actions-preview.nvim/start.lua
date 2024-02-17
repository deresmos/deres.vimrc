require("actions-preview").setup {
  diff = {
    ctxlen = 3,
  },
  backend = { "telescope", "nui" },
}

vim.keymap.set('n', '<Space>mca', '<cmd>lua require("actions-preview").code_actions()<CR>', {silent =true, noremap=true})
