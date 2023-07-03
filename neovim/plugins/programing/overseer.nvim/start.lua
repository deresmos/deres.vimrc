require('overseer').setup({
  templates = {
    "builtin",
    "user",
  },
  task_list = {
    max_width = { 100, 0.5 },
    min_width = { 100, 0.5 },
    max_height = { 20, 0.2 },
    min_height = 12,
    direction = "bottom",
  },
})
