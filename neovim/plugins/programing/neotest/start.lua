require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-go"),
  },
  consumers = {
    overseer = require("neotest.consumers.overseer"),
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✗",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = "○",
    running = "~",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "-",
    unknown = "="
  },
  output = {
    enabled = true,
    open_on_run = "short"
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15"
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false
  },
  summary = {
    animated = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      clear_marked = "M",
      clear_target = "T",
      debug = "d",
      debug_marked = "D",
      expand = { "<CR>", "<2-LeftMouse>", "l" },
      expand_all = { "e", "L" },
      jumpto = "i",
      mark = "m",
      next_failed = "J",
      output = "o",
      prev_failed = "K",
      run = "r",
      run_marked = "R",
      short = "O",
      stop = "u",
      target = "t"
    },
    open = "botright vsplit | vertical resize 50"
  }
})

local test = {}
local neotest = require('neotest')

test.run_nearest = function()
  neotest.run.run()
end
test.run_file = function()
  neotest.run.run(vim.fn.expand("%"))
end
test.run_last = function()
  neotest.run.run_last()
end
test.stop = function()
  neotest.run.stop()
end
test.open_summary = function()
  neotest.summary.toggle()
end
test.open_output = function()
  neotest.output.open({ short = false })
end
test.open_output_panel = function()
  neotest.output_panel.toggle()
end
test.jump_next = function()
  neotest.jump.next({ status = "failed" })
end
test.jump_prev = function()
  neotest.jump.prev({ status = "failed" })
end

vim.keymap.set('n', '<Space>mtn', test.run_nearest, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtf', test.run_file, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtl', test.run_last, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtq', test.stop, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mts', test.open_summary, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mto', test.open_output, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtp', test.open_output_panel, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtj', test.jump_next, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>mtk', test.jump_prev, { silent = true, noremap = true })

-- require("neotest").run.run({strategy = "dap"})
