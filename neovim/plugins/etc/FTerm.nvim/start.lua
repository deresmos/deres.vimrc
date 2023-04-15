local fterm = require('FTerm')
fterm.setup({
  border     = 'double',
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
})

vim.api.nvim_create_user_command('FTermToggle', fterm.toggle, { bang = true })
-- require('FTerm').scratch({ cmd = 'yarn build' })
