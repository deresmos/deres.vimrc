local dict = require("cmp_dictionary")

dict.setup({
  paths = { "/usr/share/dict/words" },
  exact_length = 2,
  first_case_insensitive = false,
  document = {
    enable = true,
    command = { "wn", "${label}", "-over" },
  },
})

-- dict.switcher({
--   filetype = {
--     -- javascript = { "/path/to/js.dict", "/path/to/js2.dict" },
--   },
--   filepath = {
--     -- [".*xmake.lua"] = { "/path/to/xmake.dict", "/path/to/lua.dict" },
--   },
--   spelllang = {
--     -- en = "/path/to/english.dict",
--   },
-- })
