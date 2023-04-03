function TestHydra()
   local Hydra = require('hydra')
   Hydra({
      name = 'Side scroll',
      mode = 'n',
      body = 'z',
      hint = [[123123123]],
      heads = {
         { 'h', '5zh' },
         { 'l', '5zl', { desc = '←/→' } },
         { 'H', 'zH' },
         { 'L', 'zL',  { desc = 'half screen ←/→' } },
      }
   })
end
