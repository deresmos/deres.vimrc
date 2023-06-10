require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<C-m>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        "scopes",
        "watches",
        "stacks",
        "breakpoints",
      },
      size = 55,
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.8,
    max_width = 0.9,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})


vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'GitGutterDelete', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'GitGutterAdd', linehl = '', numhl = '' })
