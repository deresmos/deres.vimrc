local M = {}

local SEPARATOR_LENGTH = 10

local setted_hydra_list = {}

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

   local hydra = require('hydra')({
      name = name,
      hint = make_hint(name, heads),
      config = config,
      heads = heads,
   })
   setted_hydra_list[name] = hydra
   return hydra
end

function M.set_hydra(name, heads, config)
   setted_hydra_list[name] = {
      name = name,
      heads = heads,
      config = config,
      lazy = true,
   }
   return function()
      M.open(name)
   end
end

function M.get_setted_hydra_names()
  local keys = {}
  for k, _ in pairs(setted_hydra_list) do
    table.insert(keys, k)
  end

  return keys
end

function M.open(name)
   local hydra = setted_hydra_list[name]

   -- 遅延読み込み処理のため、open時にhydraを作成する
   if hydra.lazy then
      hydra = set_hydra(hydra.name, hydra.heads, hydra.config)
   end

   hydra:activate()
end

return M
