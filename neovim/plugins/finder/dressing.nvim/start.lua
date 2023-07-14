require('dressing').setup({
  input = {
    prefer_width = 0.4,
    max_width = { 140, 0.9 },
    min_width = { 40, 0.4 },
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["q"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
        ["<C-k>"] = "HistoryPrev",
        ["<C-j>"] = "HistoryNext",
      },
    },
  },
})
