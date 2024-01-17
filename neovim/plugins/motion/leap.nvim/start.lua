require('leap').opts.special_keys = {
  repeat_search = '<enter>',
  next_phase_one_target = '<enter>',
  next_target = { '<enter>', ';' },
  prev_target = { '<tab>', ',' },
  next_group = '<space>',
  prev_group = '<tab>',
  multi_accept = '<enter>',
  multi_revert = '<backspace>',
}
require('leap').opts.highlight_unlabeled_phase_one_targets = true
require('leap').opts.safe_labels = ''

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = vim.api.nvim_create_augroup("my-leap-highlights", {}),
  callback = function()
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'LeapMatch', {
      fg = 'white',
      bold = true,
      nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
      fg = 'red', bold = true, nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
      fg = 'blue', bold = true, nocombine = true,
    })
  end
})
