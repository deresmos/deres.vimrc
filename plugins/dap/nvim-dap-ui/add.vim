lua << EOF
require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<C-m>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.35, -- Can be float or integer > 1
      },
      { id = "watches", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "breakpoints", size = 0.15 },
    },
    size = 55,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})


vim.fn.sign_define('DapBreakpoint', {text='●', texthl='GitGutterDelete', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='▶', texthl='GitGutterAdd', linehl='', numhl=''})

EOF
