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
    max_height = nil,  -- These can be integers or a float between 0 and 1.
    max_width = nil,   -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})


vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'GitGutterDelete', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'GitGutterAdd', linehl = '', numhl = '' })
