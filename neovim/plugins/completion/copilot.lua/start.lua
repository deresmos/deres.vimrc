require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  filetypes = {
    yaml = true,
    markdown = false,
    help = false,
    gitcommit = true,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
})

local api = require("copilot.api")
api.register_status_notification_handler(function(data)
  vim.api.nvim_set_var("copilot_status", data.status)
end)

vim.keymap.set("i", "<M-.>", "<cmd>Copilot panel<CR>", {silent=true, noremap=true})
