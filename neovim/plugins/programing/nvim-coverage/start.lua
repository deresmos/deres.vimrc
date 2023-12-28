require("coverage").setup({
  auto_reload = true,
  load_coverage_cb = function(ftype)
    vim.notify("Loaded " .. ftype .. " coverage.")
  end,
  commands = true,
  highlights = {
    covered = { fg = "#C3E88D" },
    uncovered = { fg = "#F07178" },
  },
  signs = {
    covered = { hl = "CoverageCovered", text = "▎" },
    uncovered = { hl = "CoverageUncovered", text = "▎" },
  },
  summary = {
    min_coverage = 80.0,
  },
  lang = {
    go = {
      coverage_file = "cover.out",
    },
  },
})

local coverage = require('my.coverage')
vim.keymap.set('n', '<Space>hdc', require('my.hydra').set_hydra('Coverage', {
   { 'l', coverage.load,    { desc = 'load', exit = true } },
   { 't', coverage.toggle,  { desc = 'toggle' } },
   { 'C', coverage.clear,   { desc = 'clear', exit = true } },
   { 's', coverage.summary, { desc = 'summary', exit = true } },
   { 'q', nil,              { exit = true, nowait = true, desc = 'exit', sep = '' } },
}), { silent = true, noremap = true })
