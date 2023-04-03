require("noice").setup({
  views = {
    cmdline_popup = {
      position = {
        row = 10,
        col = "50%",
      },
      size = {
        width = "60%",
        height = "auto",
      },
    },
    popup = {
      backend = "popup",
      relative = "editor",
      close = {
        events = { "BufLeave" },
        keys = { "q" },
      },
      enter = true,
      border = {
        style = "rounded",
      },
      position = "50%",
      size = {
        width = "80%",
        height = "60%",
      },
      win_options = {
        winhighlight = { Normal = "NoicePopup", FloatBorder = "NoicePopupBorder" },
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
    mini = {
      backend = "mini",
      relative = "editor",
      align = "message-right",
      timeout = 5000,
      reverse = true,
      focusable = false,
      position = {
        row = -2,
        col = "100%",
        -- col = 0,
      },
      size = {
        width = "auto",
        height = "auto",
        max_height = 20,
        max_width = 120,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      zindex = 60,
      win_options = {
        winblend = 30,
        wrap = true,
        winhighlight = {
          Normal = "NoiceMini",
          IncSearch = "",
          CurSearch = "",
          Search = "",
        },
      },
    },
    cmdline = {
      backend = "popup",
      relative = "editor",
      timeout = 1000,
      position = {
        row = -1,
        col = 0,
      },
      size = {
        height = "auto",
        width = "100%",
        max_height = 5,
        max_width = 80,
      },
      border = {
        style = "none",
      },
      win_options = {
        winhighlight = {
          Normal = "NoiceCmdline",
          IncSearch = "",
          CurSearch = "",
          Search = "",
        },
      },
    },
  },
  lsp = {
    override = {
    },
    signature = {
      enabled = false,
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = false,
    inc_rename = false,
    lsp_doc_border = true,
  },
  routes = {
    {
      view = "notify",
      filter = { event = "msg_showmode" },
    },
    {
      filter = {
        event = "msg_show",
        warning = true,
        find = "search hit BOTTOM",
      },
      opts = { skip = true },
    },
    {
      view = "cmdline",
      filter = {
        event = "msg_show",
      },
    },
    {
      view = "cmdline",
      filter = {
        find = "packer.*Compiled",
      },
    },
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "cmdline",
  },
})

vim.keymap.set("c", "<C-f>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { silent = true, noremap = true, desc = "Redirect Cmdline" })
