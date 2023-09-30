local Hydra = require('hydra')

local function create_hint(heads)
   local result = {}
   for _, head in ipairs(heads) do
      local line = ""
      if head[3].sep then
         line = string.format("%s\n", head[3].sep)
      end

      line = string.format("%s_%s_: %s", line, head[1], head[3].desc)
      table.insert(result, line)
   end

   -- resultの中身を改行した文字列にする
   return table.concat(result, "\n")
end


local function set_hydra(name, lhs, heads, config)
   config = vim.tbl_deep_extend('keep', config or {}, {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         position = 'bottom-right',
         border = 'rounded',
      },
   })

   Hydra({
      name = name,
      hint = create_hint(heads),
      config = config,
      mode = { 'n' },
      body = lhs,
      heads = heads,
   })
end

local resize_hydra = Hydra({
   name = 'Resize window',
   mode = 'n',
   config = {
      invoke_on_body = true,
   },
   body = '<Space>wr',
   heads = {
      { 'h', '<C-w>>', { desc = '→' } },
      { 'l', '<C-w><', { desc = '←' } },
      { 'H', '5<C-w>>', { desc = '5→' } },
      { 'L', '5<C-w><', { desc = '5←' } },
      { '=', '<C-w>=', { desc = '=' } },
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
set_hydra('Git', '<Space>hdg', {
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
})

local dap = require('my.dap')
set_hydra('Dap', '<Space>hdd', {
   { 'c', dap.continue,          { desc = 'continue' } },
   { 'o', dap.step_over,         { desc = 'step over' } },
   { 'i', dap.step_into,         { desc = 'step into' } },
   { 'O', dap.step_out,          { desc = 'step out' } },
   { 'B', dap.step_back,         { desc = 'step back' } },
   { 'u', dap.up,                { desc = 'up' } },
   { 'd', dap.down,              { desc = 'down', exit = true, sep = '' } },
   { 's', dap.stop,              { desc = 'stop', exit = true } },
   { 'S', dap.terminate,         { desc = 'terminate', exit = true } },
   { 'p', dap.toggle_breakpoint, { desc = 'toggle breakpoint' } },
   { 'q', nil,                   { exit = true, nowait = true, desc = 'exit', sep = '' } },
})

local coverage = require('my.coverage')
set_hydra('Coverage', '<Space>hdc', {
   { 'l', coverage.load,    { desc = 'load', exit = true } },
   { 't', coverage.toggle,  { desc = 'toggle' } },
   { 'C', coverage.clear,   { desc = 'clear', exit = true } },
   { 's', coverage.summary, { desc = 'summary', exit = true } },
   { 'q', nil,              { exit = true, nowait = true, desc = 'exit', sep = '' } },
})

local test = require('my.test')
set_hydra('Test', '<Space>hdt', {
   { 'n', test.run_nearest,   { desc = 'nearest', exit = true } },
   { 'f', test.run_file,      { desc = 'file', exit = true } },
   { 'l', test.run_last,      { desc = 'last', exit = true } },
   { 's', test.suite,         { desc = 'suite', exit = true } },
   { 'D', test.debug_mode,    { desc = 'debug mode' } },
   { 'N', test.normal_mode,   { desc = 'normal mode' } },
   { 'O', test.overseer_mode, { desc = 'overseer mode' } },
   { 'q', nil,                { exit = true, nowait = true, desc = 'exit' } },
})

local bm = require 'bookmarks'
set_hydra('Bookmarks', '<Space>hdb', {
   { 'a', bm.bookmark_ann,    { desc = 'annotation', exit = true } },
   { 't', bm.bookmark_toggle, { desc = 'toggle', exit = true } },
   { 'C', bm.bookmark_clean,  { desc = 'clean', exit = true, sep = '' } },
   { 'j', bm.bookmark_next,   { desc = 'next' } },
   { 'k', bm.bookmark_prev,   { desc = 'prev' } },
   { 'l', bm.bookmark_list,   { desc = 'list', exit = true } },
   { 'q', nil,                { exit = true, nowait = true, desc = 'exit', sep = '' } },
})
