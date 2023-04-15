local term = {}
term.count = 1

term.increment_count = function()
  term.count = term.count + 1
end

term.toggle_float = function()
  vim.cmd('1000ToggleTerm direction=float')
end
term.toggle_below = function()
  vim.cmd('1010ToggleTerm direction=horizontal size=25')
end
term.new_tab = function()
  vim.cmd(term.count .. 'ToggleTerm direction=tab size=25')
  term.increment_count()
end
term.new_vertical = function()
  local half_width = vim.api.nvim_get_option("columns") / 2
  vim.cmd(term.count .. 'ToggleTerm direction=vertical size=' .. half_width)
  term.increment_count()
end
term.new_horizontal = function()
  local half_height = vim.api.nvim_get_option("lines") / 2
  vim.cmd(term.count .. 'ToggleTerm direction=horizontal size=' .. half_height)
  term.increment_count()
end

vim.keymap.set('n', '<Space>tf', term.toggle_float, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>to', term.toggle_below, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>tt', term.new_tab, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>tv', term.new_vertical, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>ts', term.new_horizontal, { silent = true, noremap = true })
