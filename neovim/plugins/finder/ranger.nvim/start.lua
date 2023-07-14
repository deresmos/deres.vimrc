local ranger_nvim = require("ranger-nvim")
ranger_nvim.setup({
  replace_netrw = false,
  keybinds = {
    ["<C-v>"] = ranger_nvim.OPEN_MODE.vsplit,
    ["<C-s>"] = ranger_nvim.OPEN_MODE.split,
  },
})
