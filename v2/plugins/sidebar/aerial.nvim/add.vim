lua << EOF
-- Call the setup function to change the default behavior
require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown" },
  close_behavior = "auto",
  default_bindings = true,
  default_direction = "prefer_right",
  disable_max_lines = 10000,
  disable_max_size = 10000000,
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
    "Variable",
  },
  highlight_mode = "split_width",
  highlight_closest = true,
  highlight_on_hover = false,
  highlight_on_jump = 300,
  icons = {},
  ignore = {
    unlisted_buffers = true,
    filetypes = {},
    buftypes = "special",
    wintypes = "special",
  },
  link_folds_to_tree = false,
  link_tree_to_folds = true,
  manage_folds = false,
  max_width = { 40, 0.2 },
  width = nil,
  min_width = 30,
  nerd_font = "auto",
  on_attach = nil,
  open_automatic = false,
  placement_editor_edge = false,
  post_jump_cmd = "normal! zz",
  close_on_select = false,
  show_guides = false,
  update_events = "TextChanged,InsertLeave",
  guides = {
    mid_item = "├─",
    last_item = "└─",
    nested_top = "│ ",
    whitespace = "  ",
  },
  float = {
    border = "rounded",
    relative = "editor",
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.5 },
    override = function(conf)
      return conf
    end,
  },
  lsp = {
    diagnostics_trigger_update = true,
    update_when_errors = true,
    update_delay = 300,
  },
  treesitter = {
    update_delay = 300,
  },
  markdown = {
    update_delay = 300,
  },
})
EOF
