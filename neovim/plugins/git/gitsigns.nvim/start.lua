local function change_base()
  vim.ui.input({ prompt = 'Enter revision: ' }, function(input)
    require('gitsigns').change_base(input)
  end)
end

local git = {}
local gs = require('gitsigns')

function git.next_hunk()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() gs.next_hunk({ wrap = false }) end)
  return '<Ignore>'
end

function git.prev_hunk()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() gs.prev_hunk({ wrap = false }) end)
  return '<Ignore>'
end

vim.keymap.set('n', '<Space>gk', git.prev_hunk, { silent = true, noremap = true, expr = true })
vim.keymap.set('n', '<Space>gj', git.next_hunk, { silent = true, noremap = true, expr = true })
vim.keymap.set('n', '<Space>gp', "<cmd>lua require'gitsigns'.preview_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gu', "<Nop>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gU', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gU', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('x', '<Space>gU', "<cmd>lua require'gitsigns'.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>ga', "<Nop>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gA', "<cmd>lua require'gitsigns'.stage_hunk()<CR>", { silent = true, noremap = true })
vim.keymap.set('x', '<Space>gA', "<cmd>lua require'gitsigns'.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
  { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gbl', "<cmd>lua require'gitsigns'.blame_line()<CR>", { silent = true, noremap = true })

vim.keymap.set('n', '<Space>gtt', "<cmd>lua require'gitsigns'.toggle_signs()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gtw', "<cmd>lua require'gitsigns'.toggle_word_diff()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gtd', "<cmd>lua require'gitsigns'.toggle_deleted()<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<Space>gtb', "<cmd>lua require'gitsigns'.toggle_current_line_blame()<CR>",
  { silent = true, noremap = true })

vim.keymap.set('n', '<Space>gcb', change_base, { silent = true, noremap = true })
vim.keymap.set('n', '<Space>grb', "<cmd>lua require'gitsigns'.reset_base()<CR>", { silent = true, noremap = true })

require('gitsigns').setup {
  signs                             = {
    add          = { hl = 'GitSignsAdd', text = '▋', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '▋', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '▋', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    untracked    = { hl = 'GitSignsChange', text = '┆', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  signcolumn                        = true,
  numhl                             = false,
  linehl                            = false,
  watch_gitdir                      = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked               = true,
  current_line_blame                = false,
  current_line_blame_opts           = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority                     = 6,
  update_debounce                   = 100,
  status_formatter                  = function(status)
    local added, changed, removed = status.added, status.changed, status.removed
    local status_txt = {}
    if added and added > 0 then
      table.insert(status_txt, '%#GitSignsAdd#+' .. added)
    end
    if changed and changed > 0 then
      table.insert(status_txt, '%#GitSignsChange#~' .. changed)
    end
    if removed and removed > 0 then
      table.insert(status_txt, '%#GitSignsDelete#-' .. removed)
    end
    return table.concat(status_txt, ' ')
  end,
  max_file_length                   = 50000,
  preview_config                    = {
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  diff_opts                         = {
    internal = true,
  },
  word_diff                         = false,
  yadm                              = {
    enable = false
  },
}

local gitsigns = require('gitsigns')
vim.keymap.set('n', '<Space>hdg', require('my.hydra').set_hydra('Git', {
   { 'J', gitsigns.next_hunk,                                 { desc = 'next hunk' } },
   { 'K', gitsigns.prev_hunk,                                 { desc = 'prev hunk' } },
   { 'A', ':Gitsigns stage_hunk<CR>',                         { silent = true, desc = 'stage hunk' } },
   { 'U', gitsigns.undo_stage_hunk,                           { desc = 'undo last stage' } },
   -- { 'S',       gitsigns.stage_buffer,                              { desc = 'stage buffer' } },
   { 'p', gitsigns.preview_hunk,                              { desc = 'preview hunk' } },
   { 'd', gitsigns.toggle_deleted,                            { nowait = true, desc = 'toggle deleted' } },
   { 'b', gitsigns.blame_line,                                { desc = 'blame' } },
   { 'B', function() gitsigns.blame_line { full = true } end, { desc = 'blame show full' } },
   { '/', gitsigns.show,                                      { exit = true, desc = 'show base file' } }, -- show the base of the file
   { 'q', nil,                                                { exit = true, nowait = true, desc = 'exit' } },
   -- gitsigns.reset_hunk
   -- gitsigns.toggle_word_diff
}, {
   on_enter = function()
      vim.bo.modifiable = false
      gitsigns.toggle_linehl(true)
      gitsigns.toggle_deleted(true)
      gitsigns.toggle_word_diff(true)
   end,
   on_exit = function()
      gitsigns.toggle_linehl(false)
      gitsigns.toggle_deleted(false)
      gitsigns.toggle_word_diff(false)
   end,
}), { silent = true, noremap = true })
