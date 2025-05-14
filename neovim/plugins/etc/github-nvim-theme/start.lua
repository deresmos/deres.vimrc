local spec = require('github-theme.spec').load('github_dark')

require("github-theme").setup({
  options = {
    styles = {
      functions = 'NONE',
      comments = 'italic',
      keywords = 'bold',
      conditionals = 'bold',
      types = 'italic,bold',
    },
    darken = {
      floats = false,
      sidebars = {
        enable = true,
        list = { "qf", "vista_kind", "terminal", "packer" },
      },
    },
  },
  -- specs = {
  --   all = {
  --     git = {
  --       add = 'None',
  --     },
  --   },
  -- },
  groups = {
    all = {
      WinBarFileName = { fg = 'None', bg = spec.diff.add },
      diffAdded = { fg = 'None', bg = spec.diff.add },
      Folded = { bg = '#384049' },
    },
  },
  -- colors = {hint = "orange", error = "#ff0000"},
  -- overrides = function(c)
  --   return {
  --     Folded = {bg="#384049"},
  --     -- htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
  --     -- DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
  --     -- this will remove the highlight groups
  --     -- TSField = {},
  --   }
  -- end
})

vim.cmd('colorscheme github_dark_dimmed')
