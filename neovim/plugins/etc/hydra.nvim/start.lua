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
