local Hydra = require('hydra')

Hydra({
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
