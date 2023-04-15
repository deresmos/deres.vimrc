require("toggleterm").setup {
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  -- open_mapping = [[<c-\>]],
  -- hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = false,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  winbar = {
    enabled = false,
    name_formatter = function(term)
      return term.name
    end
  },
}

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term", {}),
  pattern = "term://*",
  callback = function()
    vim.keymap.set('n', 'I', 'i<C-a>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'A', 'a<C-e>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'dd', 'i<C-e><C-u><C-\\><C-n>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'cc', 'i<C-e><C-u>', { noremap = true, buffer = true })
    vim.keymap.set('n', 'q', '<cmd>quit<CR>', { noremap = true, buffer = true })
  end,
})
