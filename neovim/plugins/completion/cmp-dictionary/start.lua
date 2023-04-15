local dict = require("cmp_dictionary")

dict.setup({
  exact = 2,
  first_case_insensitive = false,
  document = false,
  document_command = "wn %s -over",
  async = false,
  max_items = -1,
  capacity = 5,
  debug = false,
})

dict.switcher({
  filetype = {
    -- javascript = { "/path/to/js.dict", "/path/to/js2.dict" },
  },
  filepath = {
    -- [".*xmake.lua"] = { "/path/to/xmake.dict", "/path/to/lua.dict" },
  },
  spelllang = {
    -- en = "/path/to/english.dict",
  },
})
