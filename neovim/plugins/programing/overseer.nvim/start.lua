require('overseer').setup({
  templates = {
    "builtin",
    "user",
  },
  component_aliases = {
    default = {
      { "display_duration", detail_level = 2 },
      "user.default",
      -- "on_output_summarize",
      "on_exit_set_status",
      "on_complete_notify",
      "on_complete_dispose",
    },
  },
  task_list = {
    max_width = { 100, 0.5 },
    min_width = { 100, 0.5 },
    max_height = { 20, 0.2 },
    min_height = 12,
    direction = "bottom",
    bindings = {
      ["?"] = "ShowHelp",
      ["g?"] = "ShowHelp",
      ["<CR>"] = "RunAction",
      ["<C-e>"] = "Edit",
      ["o"] = "Open",
      ["<C-v>"] = "OpenVsplit",
      ["<C-s>"] = "OpenSplit",
      ["<C-f>"] = "OpenFloat",
      ["<C-q>"] = "OpenQuickFix",
      ["p"] = "TogglePreview",
      ["<C-]>"] = "IncreaseDetail",
      ["<C-[>"] = "DecreaseDetail",
      ["<C-l>"] = "IncreaseAllDetail",
      ["<C-h>"] = "DecreaseAllDetail",
      ["["] = "DecreaseWidth",
      ["]"] = "IncreaseWidth",
      ["K"] = "PrevTask",
      ["J"] = "NextTask",
      ["<C-k>"] = "ScrollOutputUp",
      ["<C-j>"] = "ScrollOutputDown",
    },
  },
})