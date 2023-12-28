local M = {}

local function make_hint(heads)
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

local function set_hydra(name, heads, config)
   config = vim.tbl_deep_extend('keep', config or {}, {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         position = 'bottom-right',
         border = 'rounded',
      },
   })

   return require('hydra')({
      name = name,
      hint = make_hint(heads),
      config = config,
      heads = heads,
   })
end

function M.set_hydra(name, heads, config)
   return function()
      local x = os.clock()
      set_hydra(name, heads, config):activate()
      print (os.clock() - x)
   end
end

return M
