require('nvim-lightbulb').setup({
  ignore = {},
  sign = {
    enabled = true,
    priority = 10,
  },
  float = {
    enabled = false,
    text = "💡",
    win_opts = {},
  },
  virtual_text = {
    enabled = false,
    text = "💡",
    hl_mode = "replace",
  },
  status_text = {
    enabled = false,
    text = "💡",
    text_unavailable = ""
  },
  autocmd = {
    enabled = true,
    pattern = { "*" },
    events = { "CursorHold" }
  }
})
