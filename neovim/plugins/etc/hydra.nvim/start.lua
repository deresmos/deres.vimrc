local Hydra = require('hydra')

local resize_hydra = Hydra({
   name = 'Resize window',
   mode = 'n',
   config = {
      invoke_on_body = true,
   },
   body = '<Space>wr',
   heads = {
      { 'h', '<C-w>>',  { desc = '→' } },
      { 'l', '<C-w><',  { desc = '←' } },
      { 'H', '5<C-w>>', { desc = '5→' } },
      { 'L', '5<C-w><', { desc = '5←' } },
      { '=', '<C-w>=',  { desc = '=' } },
   }
})

local hint = [[
  ^   Translate     ^
  ^
  _j_: translate JA  ^
  _e_: translate EN  ^

]]

local translate_hydra = Hydra({
   name = 'Translate',
   hint = hint,
   mode = { 'n', 'x' },
   config = {
      invoke_on_body = true,
      hint = {
         border = 'rounded',
         position = 'middle'
      }
   },
   body = '<Space>tr',
   heads = {
      { 'j', '<cmd>Translate ja -output=replace<CR>', { desc = 'To JA', exit = true } },
      { 'e', '<cmd>Translate en -output=replace<CR>', { desc = 'To EN', exit = true } },
   }
})

-- translate_hydra:active()

local gitsigns = require('gitsigns')

local hint = [[
 _J_: next hunk   _A_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _U_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^                                     ^ ^                 _/_: show base file
 ^
 ^ ^                                     ^ ^                 _q_: exit
]]

Hydra({
   name = 'Git',
   hint = hint,
   config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         border = 'rounded'
      },
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
   },
   mode = { 'n', 'x' },
   body = '<Space>gh',
   heads = {
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
   }
})

local dap = require('dap')

hint = [[
 _J_: next hunk   _A_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _U_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^                                     ^ ^                 _/_: show base file
 ^
 ^ ^                                     ^ ^                 _q_: exit
]]

Hydra({
   name = 'Dap',
   -- hint = hint,
   config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         border = 'rounded'
      },
   },
   mode = { 'n' },
   body = '<Space>mdr',
   heads = {
      { 'c', dap.continue,          { desc = 'continue' } },
      { 's', dap.stop,              { desc = 'stop' } },
      { 'S', dap.terminate,         { desc = 'terminate', exit = true } },
      { 'o', dap.step_over,         { desc = 'step over' } },
      { 'i', dap.step_into,         { desc = 'step into' } },
      { 'O', dap.step_out,          { desc = 'step out' } },
      { 'p', dap.toggle_breakpoint, { desc = 'toggle breakpoint' } },
      { 'B', dap.step_back,         { desc = 'step back' } },
      { 'u', dap.up,                { desc = 'up' } },
      { 'd', dap.down,              { desc = 'down' } },
      { 'q', nil,                   { exit = true, nowait = true, desc = 'exit' } },
   }
})
