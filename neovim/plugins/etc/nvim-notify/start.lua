require("notify").setup({
  timeout = 4000,
  max_width = 100,
  minimum_width = 50,
  top_down = false,
  render = 'wrapped-compact',
})

vim.notify = require("notify")
