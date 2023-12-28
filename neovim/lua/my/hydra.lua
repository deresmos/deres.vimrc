local M = {}

local const SEPARATOR_LENGTH = 10

local function make_hint(name, heads)
   local separator_space = string.rep(" ", SEPARATOR_LENGTH)
   local title = string.format("[ %s ]", name)
   local result = {string.format("%s%s%s", separator_space, title, separator_space)}
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
      invoke_on_body = false,
      hint = {
         position = 'bottom-right',
         border = 'rounded',
      },
   })

   return require('hydra')({
      name = name,
      hint = make_hint(name, heads),
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
